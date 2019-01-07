//
//  ViewController.swift
//  JGWebViewExample
//
//  Created by JungMoon-Mac on 27/11/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import WebKit
import JGWebView

class ViewController: UIViewController, JGWebViewDelegate {

    @IBOutlet weak var jgWebView: JGWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jgWebView.webViewDelegate = self
        jgWebView.addUserAgentString(string: "TestApp")
        jgWebView.load(URLRequest(url: URL(string: "http://zum.com")!))
    }
}
    
extension ViewController {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        print("request \(navigationAction.request.url?.absoluteString ?? "")")
        print("allHTTPHeaderFields \(navigationAction.request.allHTTPHeaderFields?["User-Agent"] ?? "")\n\n")

        decisionHandler(.allow)
    }
}

