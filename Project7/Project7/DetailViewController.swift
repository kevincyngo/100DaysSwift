//
//  DetailViewController.swift
//  Project7
//
//  Created by Kevin Ngo on 2020-03-23.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 125%; font-family:courier,arial,helvetica; }
                .title { font-size: 175%; }
        </style>
        </head>
        <body>
        <div class="title">
        \(detailItem.title)
        </div>
        
        <br> <br>
        \(detailItem.body)
        <br> <br>
        Signature Count: \(detailItem.signatureCount)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}
