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
        NotificationCenter.default.addObserver(self, selector: #selector(endWebView(_:)), name: Notification.Name("isOver"), object: nil)
        mRedirectUrlValue = listFromInputPage["m_redirect_url"] as! String
        loadTestHtml(yourHTMLName)
        //setupConfirmationMessageHandler()
        overrideUserAgent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let htmlResourceUrl = Bundle.main.url(forResource: yourHTMLName, withExtension: "html")!
        let myRequest = URLRequest(url: htmlResourceUrl)  // RENAME
        self.webView.load(myRequest)
    }
    
    @objc func endWebView(_ notification: Notification){
        self.webView.stopLoading()
        self.webView.removeFromSuperview()
        self.webView.navigationDelegate = nil
        self.webView = nil
    }
}








