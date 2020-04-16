//
//  Injection.swift
//  Extension
//
//  Created by Kevin Ngo on 2020-04-16.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation

struct Injection: Codable {
    var title: String
    var evalString: String
    var siteURL: URL?
    
    init(
        title: String,
        evalString: String,
        siteURL: URL? = nil
    ) {
        self.title = title
        self.evalString = evalString
        self.siteURL = siteURL
    }
}
