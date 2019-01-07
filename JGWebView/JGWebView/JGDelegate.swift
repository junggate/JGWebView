//
//  JGDelegate.swift
//  JGWebView
//
//  Created by JungMoon-Mac on 07/01/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

class JGDelegate: NSObject, WKUIDelegate, WKNavigationDelegate {
    open var webViewDelegate: JGWebViewDelegate?
    open var webViewConfiguration: JGWebViewConfiguration?
    
    // MARK: - WKUIDelegate
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
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        webViewDelegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        webViewDelegate?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
        decisionHandler(.allow)
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
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        webViewDelegate?.webView?(webView, didReceive: challenge, completionHandler: completionHandler)
//        completionHandler(.useCredential, persistence())
//    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        webViewDelegate?.webViewWebContentProcessDidTerminate?(webView)
    }
}
