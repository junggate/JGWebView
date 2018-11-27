//
//  ViewController.swift
//  JGWebViewExample
//
//  Created by JungMoon-Mac on 27/11/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit
import JGWebView

class ViewController: UIViewController {

    @IBOutlet weak var jgWebView: JGWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let configuration = JGWebViewConfiguration()
        
        jgWebView.addUserAgentString(string: "TestApp")
        
        
    }
}

