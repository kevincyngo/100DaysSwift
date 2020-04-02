//
//  ViewController.swift
//  Milestone-Project10-12
//
//  Created by Kevin Ngo on 2020-04-01.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Photo Store"
        //Navigation Bar Item with (+) to access the camera
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(accessCamera))
        
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoCell else {
            fatalError("Unable to dequeue PhotoCell.")
        }

        let photo = photos[indexPath.item]
        cell.caption.text = photo.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(photo.photo)
        cell.photoImage.image = UIImage(contentsOfFile: path.path)
        
        cell.photoImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.photoImage.layer.borderWidth = 2
        cell.photoImage.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photos.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let ac = UIAlertController(title: "Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let caption = ac.textFields?[0].text else { return }
            let photo = Photo(caption: caption, photo: imageName)
            self.photos.append(photo)
            self.tableView.reloadData()
            self.save()
        })
        
//        let photo = Photo(caption: "Unknown", photo: imageName)
//        photos.append(photo)
        
//        self.save()
        dismiss(animated: true)
        self.present(ac, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = photos[indexPath.row].photo
            vc.capcap = photos[indexPath.row].caption
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func accessCamera() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }

        picker.delegate = self
        present(picker, animated: true)
    }
    
    

}

