//
//  DetailsViewController.swift
//  Milestone-Project13-15
//
//  Created by Kevin Ngo on 2020-04-08.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var capitalCityLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Canada"
        capitalCityLabel.text = "Capital City: Ottawa"
        populationLabel.text = "Population: 40,000,000"
        currencyLabel.text = "Currency: Canadian Dollar"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
