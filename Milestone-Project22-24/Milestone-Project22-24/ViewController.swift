//
//  ViewController.swift
//  Milestone-Project22-24
//
//  Created by Kevin Ngo on 2020-04-28.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = "TESTING"
        label.bounceOut(10)
        
        5.times()
        
        var numbers = [1, 2, 3, 4, 5]
        numbers.remove(3)
        print(numbers)
    }


}

extension UIView {
    //Challenge 1
    func bounceOut(_ duration: Double) {
        //define the transform
        let scale = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        
        //perform the transform over `duration` seconds
        UIView.animate(withDuration: duration, animations: {
            self.transform = scale
        })
    }
}

extension Int {
    //Challenge 2
    func times() {
        guard self > 0 else { return }
        
        for _ in 0..<self {
            print("Hello")
        }
    }
}


extension Array where Element: Comparable {
    //Challenge 3
    mutating func remove(_ item: Element) {
        //Find the item
        if let idx = self.firstIndex(of: item) {
            //Remove if element found
            self.remove(at: idx)
        }
        
    }
}
