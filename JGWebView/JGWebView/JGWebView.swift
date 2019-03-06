//
//  JGWebView.swift
//  JGWebView
//
//  Created by JungMoon-Mac on 27/11/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import WebKit

public protocol JGWebViewDelegate: WKUIDelegate, WKNavigationDelegate {
    
}

open class JGWebView: UIView {
    open var webViewDelegate: JGWebViewDelegate? {
        didSet {
            webDelegate.webViewDelegate = webViewDelegate
        }
    }
    open var webViewConfiguration: JGWebViewConfiguration?{
        didSet {
            webDelegate.webViewConfiguration = webViewConfiguration
        }
    }
    
    /// JGWebViewConfiguration.shard 사용 여부
    open var usingSharedConfiguration = true
    open var webView: WKWebView?
    open var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
    
    private let webDelegate = JGDelegate()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: - Public
    public func addUserAgentString(string: String) {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "\(string)"
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        var status = true
        var runJavascript = false
        while status {
            if runJavascript == false {
                webView.evaluateJavaScript("navigator.userAgent") { [weak self] (userAgent, error) in
                    _ = webView // 메모리 해제 방어용
                    print("addUserAgentString: \(userAgent ?? "-")")
                    self?.webView?.customUserAgent = userAgent as? String
                    status = false
                }
                runJavascript = true
            }
            
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }
    }
    
    @discardableResult open func load(_ request: URLRequest) -> WKNavigation? {
        return webView?.load(request)
    }
    
    // MARK: - Private
    private func initialize() {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), configuration: configuration)
        guard let webView = webView else { return }
        addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: webView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: webView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: webView.leftAnchor).isActive = true
        
        if usingSharedConfiguration {
            webViewConfiguration = JGWebViewConfiguration.shared
        } else {
            webViewConfiguration = JGWebViewConfiguration()
        }
        
        if let addUserAgent = webViewConfiguration?.addUserAgent {
            addUserAgentString(string: addUserAgent)
        }
        
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        
        webView.uiDelegate = webDelegate
        webView.navigationDelegate = webDelegate
    }
}
