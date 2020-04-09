//
//  Country.swift
//  Milestone-Project13-15
//
//  Created by Kevin Ngo on 2020-04-08.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation

struct Country: Codable {
    var country: String
    var capital: String
    var population: Int
    var currency: String
    var facts: [String]
}
