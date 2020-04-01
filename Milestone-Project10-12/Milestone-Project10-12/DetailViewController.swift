//
//  DetailViewController.swift
//  Milestone-Project10-12
//
//  Created by Kevin Ngo on 2020-04-01.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String?
//    var currentImagesNum: Int?
//    var totalImagesNum: Int?
    var capcap: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(imageToLoad).path)
        }
        title = "\(capcap ?? "")"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
