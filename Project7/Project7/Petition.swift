//
//  Petition.swift
//  Project7
//
//  Created by Kevin Ngo on 2020-03-23.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
