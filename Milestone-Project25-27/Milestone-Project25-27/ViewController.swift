//
//  ViewController.swift
//  Milestone-Project25-27
//
//  Created by Kevin Ngo on 2020-05-01.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit


//MARK: Improvements: disable text buttons if image not imported, don't force unwrap

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "activityViewControllerPlaceholderItem"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return "itemForActivityType"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Secret message"
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageViewSize: CGSize {
        imageView.frame.size
    }
    
    //storing the default image
    var originalImage: UIImage? = nil
    
    var topText: String = ""
    var botText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "memeGEN"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importImage)),
            UIBarButtonItem(title: "T", style: .plain, target: self, action: #selector(addTopText)),
            UIBarButtonItem(title: "B", style: .plain, target: self, action: #selector(addBotText))
        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareImage))
        
    }
    
    //Import the image
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        imageView.image = image
        originalImage = imageView.image
        
    }
    
    //Add text to top of image
    @objc func addTopText() {
        let ac = UIAlertController(title: "Enter top text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            self.topText = ac.textFields![0].text ?? ""
            //edit the top of the image
            self.imageView.image = self.textToImage()
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
        
    }
    
    //Add text to bot of image
    @objc func addBotText() {
        let ac = UIAlertController(title: "Enter bottom text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            self.botText = ac.textFields![0].text ?? ""
            //edit the bottom of the image
            self.imageView.image = self.textToImage()
            
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
        
    }
    
    //Share the image
    @objc func shareImage() {
        let item = [imageView.image]
        let ac = UIActivityViewController(activityItems: item as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
    func drawRectangle() {
        
        let renderer = UIGraphicsImageRenderer(size: imageViewSize)
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: imageViewSize.width, height: imageViewSize.height)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func textToImage() -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 64)!
        let strokeColor = UIColor.black
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.originalImage!.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.strokeWidth : -3,
            NSAttributedString.Key.strokeColor: strokeColor
            ] as [NSAttributedString.Key : Any]
        
        self.originalImage!.draw(in: CGRect(origin: CGPoint.zero, size: self.originalImage!.size))
        
        let topRect = CGRect(origin: CGPoint(x: 20, y: 20), size: self.originalImage!.size)
        self.topText.draw(in: topRect, withAttributes: textFontAttributes)
        
        let botRect = CGRect(origin: CGPoint(x: 20, y: (self.imageView.image?.size.height)! - 84), size: self.originalImage!.size)
        self.botText.draw(in: botRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}

