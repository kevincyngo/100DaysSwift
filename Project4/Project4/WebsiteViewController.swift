//
//  WebsiteViewController.swift
//  Project4
//
//  Created by Kevin Ngo on 2020-03-16.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController {
    @IBOutlet @objc dynamic var webView: WKWebView!
    var progressView: UIProgressView!
    
    var website: Website!
    var progressObserver: NSKeyValueObservation! = nil


    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = website.displayName
        webView.load(URLRequest(url: website.url))
        
        webView.allowsBackForwardNavigationGestures = true
        
        setupToolbar()
        observeProgress()
    }
    
    //Observer to check the progress of the page load
    func observeProgress() {
        progressObserver = self.observe(\.webView.estimatedProgress) { [unowned self] (_, _) in
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
    //Toolbar (bar at bottom of screen) setup
    func setupToolbar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let progressButton = UIBarButtonItem(customView: progressView)
        let backButton = UIBarButtonItem(title: "◀️", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "▶️", style: .plain, target: webView, action: #selector(webView.goForward))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    //Alert to be displayed when visiting blocked site
    func displayUnauthorizedSiteAlert() {
        let alertController = UIAlertController(
            title: "Unauthorized Host 🛑",
            message: "The Internet is a scary place. Please do not try accessing sites with host names that aren't on our list.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Sorry", style: .default))
        
        present(alertController, animated: true)
    }
    
}
//Ran when site is visited to check if site is blocked or not
extension WebsiteViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in Website.allWebsites {
                if host.contains(website.hostName ?? "") {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
        displayUnauthorizedSiteAlert()
    }
    
    //Called when navigation is complete
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
