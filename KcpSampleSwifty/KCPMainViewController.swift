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
    
    var listFromInputPage : [String: Any] = ["":""]
    
    
    var mRedirectUrlValue : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadFirstPage(_:)), name: Notification.Name("isOver"), object: nil)
        
        mRedirectUrlValue = listFromInputPage["m_redirect_url"] as! String
        loadTestHtml(yourHTMLName)
        setupConfirmationMessageHandler()
        overrideUserAgent()
        
        
    }
    
    @objc func loadFirstPage(_ notification: Notification){
        //처음 앱으로 돌아가는것 TODO
        loadTestHtml("IamportTest")
    }
}








