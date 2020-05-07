//
//  Card.swift
//  Milestone-Projects28-30
//
//  Created by Kevin Ngo on 2020-05-07.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation
import UIKit

enum CardState {
    case front
    case back
    case matched
    case complete
}

struct Card {
    var cardState: CardState = .back
//    var name: String
    var front: String
    var back = "1PlayingCards_back.png"
    
    
    
}
