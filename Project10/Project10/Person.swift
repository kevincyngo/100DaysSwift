//
//  Person.swift
//  Project10
//
//  Created by Kevin Ngo on 2020-03-28.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
