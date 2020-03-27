//
//  ViewController.swift
//  Milestone-Project7-9
//
//  Created by Kevin Ngo on 2020-03-26.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let LETTERS = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let WORD_BANK = ["DOUCHE", "TWITTER", "ANAGRAM", "GNARLY", "FANTASTIC"]
    
    var selectedLetter = ""
    var actualAnswerString = ""
    var currentAnswerString = "" {
        didSet {
            currentAnswer.text = currentAnswerString
        }
    }
    
    var guessesRemaining = 5 {
        didSet {
            guessLabel.text = "You have \(guessesRemaining) guesses left."
        }
    }
    
    //Holds the current Answer
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var selectedButton: UIButton!
    var guessLabel: UILabel!
    var buttonsView = UIView()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        guessLabel = UILabel()
        //determines if views autoresizing mask is translated into auto layout constraints
        guessLabel.translatesAutoresizingMaskIntoConstraints = false
        guessLabel.textAlignment = .right
        guessLabel.text = "You have 5 guesses left."
        view.addSubview(guessLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 42)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let widthLetter = 70
        let heightLetter = 70
        let widthSubmit = 280
        
        // create 25 buttons as a 5x5 grid
        for row in 0..<5 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle(LETTERS[row*5 + col], for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * widthLetter, y: row * heightLetter, width: widthLetter, height: heightLetter)
                letterButton.frame = frame
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.layer.cornerRadius = 5
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.black.cgColor
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
            }
        }
        
        //add final row (Z, submit button)
        let letterButton = UIButton(type: .system)
        letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        letterButton.setTitle(LETTERS[25], for: .normal)
        let frameLetter = CGRect(x: 0 * widthLetter, y: 5 * heightLetter, width: widthLetter, height: heightLetter)
        letterButton.frame = frameLetter
        letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        letterButton.layer.cornerRadius = 5
        letterButton.layer.borderWidth = 1
        letterButton.layer.borderColor = UIColor.black.cgColor
        buttonsView.addSubview(letterButton)
        
        let submit = UIButton(type: .system)
        submit.setTitle("SUBMIT", for: .normal)
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        submit.addTarget(self, action: #selector(submitLetter), for: .touchUpInside)
        let frameSubmit = CGRect(x: 1 * widthLetter, y: 5 * heightLetter, width: widthSubmit, height: heightLetter)
        submit.frame = frameSubmit
        submit.layer.cornerRadius = 5
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.black.cgColor
        buttonsView.addSubview(submit)
        
        NSLayoutConstraint.activate([
            guessLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor),
            currentAnswer.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.heightAnchor.constraint(equalToConstant: 420),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    func loadLevel() {
        actualAnswerString = WORD_BANK.randomElement()!
        currentAnswerString = String.init(repeating: "?", count: actualAnswerString.count)
    }
    
    func clearBackground(isSubmit: Bool = false) {
        for view in buttonsView.subviews {
            if view.backgroundColor == .yellow {
                view.backgroundColor = .white
                if isSubmit {
                    view.isHidden = true
                }
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        clearBackground()
        guard let letter = sender.titleLabel?.text else { return }
        selectedLetter = letter
        sender.backgroundColor = .yellow
    }
    
    @objc func submitLetter() {
        clearBackground(isSubmit: true)
        var isCorrectLetter = false
        for (index,letter) in actualAnswerString.enumerated() {
            if selectedLetter == actualAnswerString[index] {
                currentAnswerString = currentAnswerString.substring(toIndex: index) + String(letter) + currentAnswerString.substring(fromIndex: index+1)
                isCorrectLetter = true
            }
        }
        selectedLetter = ""
        if !isCorrectLetter {
            guessesRemaining -= 1
        }

    }
    
    
}


extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
