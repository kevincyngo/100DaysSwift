//
//  DetailViewController.swift
//  Milestone-Project19-21
//
//  Created by Kevin Ngo on 2020-04-22.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    var note: Note = Note(title: "TEST", date: Date(), description: "TEST")
    var notes = [Note]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = note.description
        navigationController?.delegate = self

    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveNote()
    }
    
    func saveNote() {
        note.title = textView.text.components(separatedBy: "\n")[0]
        note.description = textView.text
        note.date = Date()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedNotes")
        }
    }
    
}

extension DetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? ViewController)?.tableView.reloadData()
    }
}
