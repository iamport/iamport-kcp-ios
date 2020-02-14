//
//  InitViewController.swift
//  KcpSampleSwift
//
//  Created by iamport on 14/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit


protocol SendDataDelegate {
    func sendData(data: [String: Any])
}


class InitViewController : UIViewController  {

    var delegate : SendDataDelegate?
    
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
        delegate?.sendData(data: list)
        dismiss(animated: true, completion: nil)
    }
}
