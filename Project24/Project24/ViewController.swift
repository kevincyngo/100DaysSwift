//
//  ViewController.swift
//  Project24
//
//  Created by Kevin Ngo on 2020-04-26.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //challenge 1
        print("pet".withPrefix("car"))
        print("carpet".withPrefix("car"))
        
        //challenge 2
        print("11.5".isNumeric)
        print("KK".isNumeric)
        
        //challenge 3
        print("this\nis\na\ntest".addLines)
    }


}

extension String {
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    //We could add our own specialized capitalization that uppercases only the first letter in our string:
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
    
    //challenge 1
    func withPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {return prefix + self}
        return self
    }
    
    //challenge 2
    var isNumeric: Bool {
        guard (Double(self) != nil) else {return false}
        return true
    }
    
    //challenge 3
    var addLines: [String] {
        return self.components(separatedBy: "\n")
    }
}

