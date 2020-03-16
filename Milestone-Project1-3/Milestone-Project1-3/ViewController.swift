//
//  ViewController.swift
//  Milestone-Project1-3
//
//  Created by Kevin Ngo on 2020-03-15.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var flagsGlobal = [String]()
    var lengthOfSuffix = "@2x.png".count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let flags = try! fm.contentsOfDirectory(atPath: path)
        
        for flag in flags {
            if flag.hasSuffix(".png") {
                flagsGlobal.append(String(flag.prefix(flag.count - lengthOfSuffix).uppercased()))
            }
        }
        
        flagsGlobal.sort() {
            $0 < $1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagsGlobal.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flagsGlobal[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedFlag = flagsGlobal[indexPath.row].lowercased() + "@2x.png"
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

