//
//  ViewController.swift
//  Milestone-Project13-15
//
//  Created by Kevin Ngo on 2020-04-08.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Country Factoids"
        countries.append("Canada")
        countries.append("United States")
        countries.append("England")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Insert row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
            // 2: success! Set its selectedImage property
//            vc.selectedImage = pictures[indexPath.row]
//            vc.currentImagesNum = indexPath.row + 1
//            vc.totalImagesNum = pictures.count
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

