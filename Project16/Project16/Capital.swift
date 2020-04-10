//
//  Capital.swift
//  Project16
//
//  Created by Kevin Ngo on 2020-04-10.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
