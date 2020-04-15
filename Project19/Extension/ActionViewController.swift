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

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //When our extension is created, its extensionContext lets us control how it interacts with the parent app. In the case of inputItems this will be an array of data the parent app is sending to our extension to use.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            
            //Our input item contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item.
            if let itemProvider = inputItem.attachments?.first {
                
                //The next line uses loadItem(forTypeIdentifier: ) to ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. That is, the method will carry on executing while the item provider is busy loading and sending us its data.

                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    
                    //Inside our closure we first need the usual [weak self] to avoid strong reference cycles, but we also need to accept two parameters: the dictionary that was given to us by the item provider, and any error that occurred.
                    [weak self] (dict, error) in
                }
            }
        }
        

    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
