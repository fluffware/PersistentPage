//
//  WebBrowserController.swift
//  SwiftToy
//
//  Created by Simon on 2019-02-15.
//  Copyright © 2019 Elektro-Kapsel AB. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserController: UIViewController , WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var settings: PageSettings?
    
    override func viewDidLoad() {
        webView.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let request = URLRequest(url: settings!.url)
        webView.load(request)
        
    }
}

