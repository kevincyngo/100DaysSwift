//
//  ViewController.swift
//  Milestone-Project13-15
//
//  Created by Kevin Ngo on 2020-04-08.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country Factoids"
        parse()
    }
    
    
    func parse(){
        if let path = Bundle.main.path(forResource: "CountryInformation", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                do {
                    // get the data from JSON file with help of struct and Codable
                    let countryModel = try decoder.decode(Countries.self, from: data)
                    // from here you can populate data in tableview
                    countries = countryModel.results
                    tableView.reloadData()
                }catch{
                    print(error) // shows error
                    print("Decoding failed")// local message
                }
                
            } catch {
                print(error) // shows error
                print("Unable to read file")// local message
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Insert row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
            // 2: success! Set its selectedImage property
            vc.country = countries[indexPath.row]
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

