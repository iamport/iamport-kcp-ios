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

    //결제 완료 후 return되는 정보가 저장됩니다.
    //item.name : item.value
    //[imp_uid : imp_12341234]
    //[merchant_uid: ORD12341234-12341234]
    //[imp_success : true/false]
    //[errer_msg : error!!]
    var returnFromPaymentEndJSON : String? = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupConfirmationMessageHandler()
        loadTestHtml()
        overrideUserAgent()
    }

}






