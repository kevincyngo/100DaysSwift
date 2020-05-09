//
//  ViewController.swift
//  Milestone-Projects28-30
//
//  Created by Kevin Ngo on 2020-05-07.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

enum Suit: String, CaseIterable {
    case spades = "Spades"
    case diamonds = "Diamonds"
    case hearts = "Hearts"
    case clubs = "Clubs"
}

enum Number: String, CaseIterable {
    case ace = "A"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "J"
    case queen = "Q"
    case king = "K"
}



class ViewController: UIViewController {
    
    var cards = [Card]()
    var selectedCards = [Card]()
    
    //MARK: -Only allow two cards to be flipped at a time
    //MARK: -Add a nav bar button to allow user to start a new game
    //MARK: -Add a timer to track how long it takes user to complete
    
    fileprivate let collectionView: UICollectionView = {
        let spacing:CGFloat = 15.0
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    func loadData() {
        
        
        var deckOfCards = [String]()
        for suit in Suit.allCases {
            for number in Number.allCases {
                deckOfCards.append("\(suit.rawValue)_\(number.rawValue).png")
            }
        }
        deckOfCards.shuffle()
        
        for card in deckOfCards {
            if cards.count == 12 {
                break
            }
            cards.append(Card(front: card))

        }
        cards += cards
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memory Game"
        
        view.addSubview(collectionView)
        view.backgroundColor = .black
        
        //Conformance to CollectionView Data Source and Delegate Protocols
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        loadData()
    }
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //Size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height/8)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        cell.data = self.cards[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        cell.toggleClick()
        
    }
        
}
