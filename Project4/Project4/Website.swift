//
//  Website.swift
//  Project4
//
//  Created by Kevin Ngo on 2020-03-16.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation

struct Website {
    static var allWebsites: [Website] = []
    
    var displayName: String
    var url: URL
    
    var hostName: String? {
        return self.url.host
    }
    
    init(displayName: String, url: URL) {
        self.displayName = displayName
        self.url = url
        
        Website.allWebsites.append(self)
    }
}
