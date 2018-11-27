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

open class JGWebView: UIView, WKUIDelegate, WKNavigationDelegate {
    open var webViewDelegate: JGWebViewDelegate?
    open var webViewConfiguration: JGWebViewConfiguration?
    
    /// JGWebViewConfiguration.shard 사용 여부
    open var usingSharedConfiguration = true
    
    private var webView: WKWebView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Public
    public func addUserAgentString(string: String) {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "\(string)"
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.evaluateJavaScript("navigator.userAgent") { [weak self] (userAgent, error) in
            _ = webView // 메모리 해제 방어용
            print("addUserAgentString: \(userAgent ?? "-")")
            self?.webView?.customUserAgent = userAgent as? String
        }
    }
    
    @discardableResult open func load(_ request: URLRequest) -> WKNavigation? {
        return webView?.load(request)
    }
    
    // MARK: - Private
    private func initialize() {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), configuration: WKWebViewConfiguration())
        guard let webView = webView else { return }
        addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: webView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: webView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: webView.leftAnchor).isActive = true
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
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
    }
}
    // MARK: - WKUIDelegate
extension JGWebView {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return webViewDelegate?.webView?(webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webViewDelegate?.webViewDidClose?(webView)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        if webViewConfiguration?.showAlertController ?? false {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            
            rootViewController?.present(alertController, animated: true, completion: nil)
        }

        webViewDelegate?.webView?(webView, runJavaScriptAlertPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        webViewDelegate?.webView?(webView, runJavaScriptConfirmPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        webViewDelegate?.webView?(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return webViewDelegate?.webView?(webView, shouldPreviewElement: elementInfo) ?? false
    }
    
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        return webViewDelegate?.webView?(webView, previewingViewControllerForElement: elementInfo, defaultActions: previewActions)
    }
    
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        webViewDelegate?.webView?(webView, commitPreviewingViewController: previewingViewController)
    }
}
    // MARK: - WKNavigationDelegate
extension JGWebView {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        webViewDelegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        webViewDelegate?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewDelegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didCommit: navigation)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewDelegate?.webView?(webView, didFail: navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        webViewDelegate?.webView?(webView, didReceive: challenge, completionHandler: completionHandler)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        webViewDelegate?.webViewWebContentProcessDidTerminate?(webView)
    }
}
