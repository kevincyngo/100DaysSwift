//
//  Photo.swift
//  Milestone-Project10-12
//
//  Created by Kevin Ngo on 2020-04-01.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation

class Photo: NSObject, Codable {
    var caption: String
    var photo: String
    
    init(caption: String, photo: String) {
        self.caption = caption
        self.photo = photo
    }
}
