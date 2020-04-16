//
//  ActionViewController.swift
//  Extension
//
//  Created by Kevin Ngo on 2020-04-15.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    let notificationCenter = NotificationCenter.default
    
    var injectionPresets = [Injection]()
    
    func loadPresets() {
        //load from userdefaults
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Injection].self, from: data) {
                print(decoded)
                self.injectionPresets = decoded
                return
            }
        }
        
        //if userdefault load fails, load from json presets
        if let path = Bundle.main.path(forResource: "injection-presets", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                do {
                    // get the data from JSON file with help of struct and Codable
                    self.injectionPresets = try decoder.decode([Injection].self, from: data)
                    self.saveToUserDefault()
                    return
                }catch{
                    print(error) // shows error
                    print("Decoding failed")// local message
                }
            } catch {
                print(error) // shows error
                print("Unable to read file")// local message
            }
        }
        
        //if both userdefault and json fail, set to empty array
        self.injectionPresets = []
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(displayPresets))
        
        loadPresets()
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //When our extension is created, its extensionContext lets us control how it interacts with the parent app. In the case of inputItems this will be an array of data the parent app is sending to our extension to use.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            
            //Our input item contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item.
            if let itemProvider = inputItem.attachments?.first {
                
                //The next line uses loadItem(forTypeIdentifier: ) to ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. That is, the method will carry on executing while the item provider is busy loading and sending us its data.
                
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    
                    //Inside our closure we first need the usual [weak self] to avoid strong reference cycles, but we also need to accept two parameters: the dictionary that was given to us by the item provider, and any error that occurred.
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    //data will appear in the finalize function of Action.js
    @IBAction func done(_ presetScript: String = "") {
        let item = NSExtensionItem()
        let argument: NSDictionary
        
        //add alert in here to save to userdefaults (alert with textfield)
        if presetScript == "" {
            argument = ["customJavaScript": script.text!]
            
            //saveToUserDefault()
        } else {
            argument = ["customJavaScript": presetScript]
        }
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
        
    }
    
    func saveToUserDefault() {
        if let encoded = try? JSONEncoder().encode(injectionPresets) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
    
    //challenge 1
    @IBAction func displayPresets() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        
        for (idx, injection) in injectionPresets.enumerated() {
            alert.addAction(UIAlertAction(title: injection.title, style: .default, handler: { action in
                self.injectionPresets[idx].siteURL = URL(string: self.pageURL)
                self.saveToUserDefault()
                self.done(injection.evalString)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}
