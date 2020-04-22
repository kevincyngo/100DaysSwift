//
//  ViewController.swift
//  Milestone-Project19-21
//
//  Created by Kevin Ngo on 2020-04-21.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func add(_ sender: Any) {
        print("add new note")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        tableView.contentInset = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    @objc func addTapped() {
      print("add new note")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteTableViewCell
        
        cell.dateLabel.text = "2020-04-20"
        cell.descriptionLabel.text = "Test Description Label"
        cell.titleLabel.text = "Test Note"
        
        return cell
        
    }


}

