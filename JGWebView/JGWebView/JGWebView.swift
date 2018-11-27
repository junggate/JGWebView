//
//  JGWebView.swift
//  JGWebView
//
//  Created by JungMoon-Mac on 27/11/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import WebKit

open class JGWebView: WKWebView, WKUIDelegate, WKNavigationDelegate {
    
    open var webViewDelegate: (WKUIDelegate & WKNavigationDelegate)?
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        initialize()
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func initialize() {
        self.uiDelegate = self
        self.navigationDelegate = self
    }
    
}

// MARK: - WKUIDelegate
extension JGWebView {
    private func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return webViewDelegate?.webView?(webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
    }
    
    private func webViewDidClose(_ webView: WKWebView) {
        webViewDelegate?.webViewDidClose?(webView)
    }
    
    private func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        webViewDelegate?.webView?(webView, runJavaScriptAlertPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    private func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        webViewDelegate?.webView?(webView, runJavaScriptConfirmPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    private func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        webViewDelegate?.webView?(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    private func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return webViewDelegate?.webView?(webView, shouldPreviewElement: elementInfo) ?? false
    }
    
    private func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        return webViewDelegate?.webView?(webView, previewingViewControllerForElement: elementInfo, defaultActions: previewActions)
    }
    
    private func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        webViewDelegate?.webView?(webView, commitPreviewingViewController: previewingViewController)
    }

}

// MARK: - WKNavigationDelegate
extension JGWebView {
    private func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        webViewDelegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    private func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        webViewDelegate?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
    }
    
    private func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    private func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }
    
    private func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewDelegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
    
    private func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didCommit: navigation)
    }
    
    private func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewDelegate?.webView?(webView, didFinish: navigation)
    }
    
    private func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewDelegate?.webView?(webView, didFail: navigation, withError: error)
    }
    
    private func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        webViewDelegate?.webView?(webView, didReceive: challenge, completionHandler: completionHandler)
    }
    
    private func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        webViewDelegate?.webViewWebContentProcessDidTerminate?(webView)
    }
}
