//
//  DetailViewController.swift
//  Project1
//
//  Created by Kevin Ngo on 2020-03-11.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }

    }
    
    



}
