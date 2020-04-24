//
//  Note.swift
//  Milestone-Project19-21
//
//  Created by Kevin Ngo on 2020-04-22.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import Foundation

class Note: Codable {
    var title: String
    var date: Date
    var description: String
    
    var stringDate: String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    init(title: String, date: Date, description: String) {
        self.title = title
        self.date = Date()
        self.description = description
    }

}
