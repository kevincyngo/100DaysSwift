//
//  ViewController.swift
//  Project2
//
//  Created by Kevin Ngo on 2020-03-13.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var wrongMessage = ""
    let metrics = ["labelHeight": 88]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased() + ", Score: \(score)"

    }

    func resetGame() {
        score = 0
        correctAnswer = 0
        questionsAsked = 0
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct"
        } else {
            score -= 1
            title = "Incorrect"
            wrongMessage = "That's the flag of \(countries[sender.tag].uppercased())"
        }
        questionsAsked += 1
        
        if score == 10 {
            let ac = UIAlertController(title: title, message: "Your final score is \(score)/\(questionsAsked).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            resetGame()
            present(ac, animated: true)
        } else if title == "Incorrect" {
            let ac = UIAlertController(title: title, message: wrongMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        else {
            askQuestion(action: nil)

        }
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Score", message: "\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
}

