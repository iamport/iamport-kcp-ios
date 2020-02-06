//
//  KCPMainViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit


class KCPMainViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!

    //HTML로 부터온 m_redirect_url
    var mRedirectUrlValue : String = ""
    
    //변경가능
    let yourHTMLName : String = "IamportTest"//.html
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupConfirmationMessageHandler()
        loadTestHtml()
        overrideUserAgent()
        
    }
    

}






