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
    
    var notes = [Note]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        tableView.delegate = self
        tableView.dataSource = self
        loadNotes()
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    func loadNotes() {
        if let savedNotes = UserDefaults.standard.object(forKey: "SavedNotes") as? Data {
            let decoder = JSONDecoder()
            if let loadedNotes = try? decoder.decode([Note].self, from: savedNotes) {
                notes = loadedNotes
            }
        }
    }
    
    
    @IBAction func addNote(_ sender: Any) {
//        notes.append(Note(title: "addTappedNode", date: Date(), description: "addTappedNode"))
//        tableView.reloadData()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            notes.append(Note(title: "", date: Date(), description: ""))
            vc.note = notes.last!
            vc.notes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.date.text = note.stringDate
        cell.descriptionLabel.text = String(note.description.prefix(32))
        cell.title.text = String(note.title.prefix(32))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.note = notes[indexPath.row]
            vc.notes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

