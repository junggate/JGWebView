//
//  JGWebViewConfiguration.swift
//  JGWebView
//
//  Created by JungMoon-Mac on 27/11/2018.
//  Copyright © 2018 JungMoon. All rights reserved.
//

import UIKit

open class JGWebViewConfiguration: NSObject {
    public static var shared: JGWebViewConfiguration?
    
    open var showAlertController:Bool = true
    open var addUserAgent: String?
}
