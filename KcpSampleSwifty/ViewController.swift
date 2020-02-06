//
//  ViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    //HTML로 부터온 m_redirect_url
    var mRedirectUrlValue : String = ""

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupConfirmationMessageHandler()
        loadTestHtml()
        overrideUserAgent()
        
    }
    

}






