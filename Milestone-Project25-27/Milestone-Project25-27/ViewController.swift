//
//  ViewController.swift
//  Milestone-Project25-27
//
//  Created by Kevin Ngo on 2020-05-01.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageViewSize: CGSize {
        imageView.frame.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "memeGEN"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: #selector(importImage)),
            UIBarButtonItem(title: "T", style: .plain, target: self, action: #selector(addTopText)),
            UIBarButtonItem(title: "B", style: .plain, target: self, action: #selector(addBotText))
        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareImage))
        
        drawRectangle()
    }
    
    //Import the image
    @objc func importImage() {
        
    }
    
    //Add text to top of image
    @objc func addTopText() {
        
    }
    
    //Add text to bot of image
    @objc func addBotText() {
        
    }
    
    //Share the image
    @objc func shareImage() {
        
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
    
    
}

