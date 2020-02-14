//
//  InitViewController.swift
//  KcpSampleSwift
//
//  Created by iamport on 14/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit


class InitViewController : UIViewController  {
    
    //입력받아야됨 TODO
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
    
    @IBAction func sendJSON(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "ToWebView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWebView" {
            let toKCPMain = segue.destination as! KCPMainViewController
            toKCPMain.listFromInputPage = list
        }
    }
    
}

