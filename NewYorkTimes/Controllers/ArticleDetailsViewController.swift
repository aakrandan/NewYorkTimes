//
//  ArticleDetailsViewController.swift
//  NewYorkTimes
//
//  Created by Ananth Kamath on 10/06/22.
//

import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var articleView = WKWebView()
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleView.navigationDelegate = self
        self.view.addSubview(articleView)
        
        let url = URL(string: urlString ?? "")
        
        if let url = url {
            articleView.load(URLRequest(url: url))
        }
        
        self.articleView.addSubview(self.activity)
        activity.translatesAutoresizingMaskIntoConstraints = false

        self.activity.centerXAnchor.constraint(equalTo: self.articleView.centerXAnchor, constant: 0).isActive = true
        self.activity.centerYAnchor.constraint(equalTo: self.articleView.centerYAnchor).isActive = true
        
        self.activity.startAnimating()
        articleView.isUserInteractionEnabled = false
        self.articleView.navigationDelegate = self
        self.activity.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        articleView.frame = view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        articleView.removeFromSuperview()
    }
    
}

extension ArticleDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
        articleView.isUserInteractionEnabled = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activity.stopAnimating()
        articleView.isUserInteractionEnabled = true
    }
}
