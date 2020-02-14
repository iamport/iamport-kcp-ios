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

    //HTML로 부터온 m_redirect_url
    var mRedirectUrlValue : String = ""
    
    //변경가능
    let yourHTMLName : String = "IamportTest"//.html
    
    var tmp : [String: Any] = ["":""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        let source = "request_pay(\(list.jsonStringRepresentation!))"
        
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        view = webView
    
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    
        let htmlResourceUrl = Bundle.main.url(forResource: yourHTMLName, withExtension: "html")!
        let myRequest = URLRequest(url: htmlResourceUrl)  // RENAME
        self.webView.load(myRequest)
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadFirstPage(_:)), name: Notification.Name("isOver"), object: nil)
        
        setupConfirmationMessageHandler()
        //loadTestHtml("IamportTest")//.html
        overrideUserAgent()
    }
    
    
    
    let list : [String : Any] =
        [
            "pg" : "kcp",
            "pay_method" : "card",
            "merchant_uid" : "ORD20202020 -00000127",
            "name" : "노르웨이",
            "amount" : "1000",
            "buyer_email" : "gildong@gmail.com",
            "buyer_name" : "홍길동",
            "buyer_tel" : "010-2020-2020",
            "buyer_addr" : "서울특별시 강남구 신사동",
            "buyer_postcode" : "01181",
            "app_scheme" : "iamporttest",
            "m_redirect_url" : "https://www.naver.com/"
            
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWebView" {

                    let viewController : InitViewController = segue.destination as! InitViewController

                        viewController.delegate = self

                }

    }
    

    
    @objc func loadFirstPage(_ notification: Notification){
        //처음 앱으로 돌아가는것 TODO
        loadTestHtml("IamportTest")
    }
}








