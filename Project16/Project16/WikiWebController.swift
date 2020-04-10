//
//  WikiWebController.swift
//  Project16
//
//  Created by Kevin Ngo on 2020-04-10.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import WebKit

class WikiWebController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var capital: String!
    
    let baseURL = "https://en.wikipedia.org/wiki/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let urlString = baseURL + parseCapital()
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func parseCapital() -> String {
        capital.replacingOccurrences(of: " ", with: "_")
    }

}
