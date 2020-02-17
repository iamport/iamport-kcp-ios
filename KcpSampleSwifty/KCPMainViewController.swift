//
//  KCPMainViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit


class KCPMainViewController: UIViewController{
    
    @IBOutlet var webView: WKWebView!

    //변경가능
    let yourHTMLName : String = "IamportTest"//.html
    
    var listFromInputPage = [String: Any]()
    var listFromKcpMain = [String: Any]()
    
    var mRedirectUrlValue : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEndNotification()
        getRedirectURLFromInput()
        setupMessageHandler(yourHTMLName)
        overrideUserAgent()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadHTML(yourHTMLName)
    }
    
}








