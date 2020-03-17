//
//  ViewController.swift
//  Project5
//
//  Created by Kevin Ngo on 2020-03-17.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        //Find the file start.txt
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //If file found, try to get words
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        //If no words, use default word of silkworm
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
    }
    
    func startGame() {
        //sets view controller's title to be a random word
        title = allWords.randomElement()
        
        //removes all values from the usedWords array, which we will use to store the player's answers so far
        usedWords.removeAll(keepingCapacity: true)
        
        //calls reloadData() method of tableView
        //The table view is given to us as a property b/c our VC comes from UITableVC
        //calling reloadData() forces it to call numberOfRowsInSection and cellForRowAt
        tableView.reloadData()
    }

}

