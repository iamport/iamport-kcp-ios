//
//  InitViewController+IamportKcp.swift
//  KcpSampleSwift
//
//  Created by iamport on 17/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

// MARK: - segue 변경 시 list를 다른 ViewController에 전달

extension InitViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        getListFromInput()
        
        if segue.identifier == "ToWebView" {
            let toKCPMain = segue.destination as! KCPMainViewController
            toKCPMain.listFromInputPage = listFromInput
            print(toKCPMain.listFromInputPage)
        }
    }
    
    func getListFromInput() {
        
        self.listFromInput["pg"] = self.pg.text
        self.listFromInput["pay_method"] = self.payMethod.text
        self.listFromInput["merchant_uid"] = self.merchantUid.text
        self.listFromInput["name"] = self.name.text
        self.listFromInput["amount"] = self.amount.text
        self.listFromInput["buyer_email"] = self.buyerEmail.text
        self.listFromInput["buyer_name"] = self.buyerName.text
        self.listFromInput["buyer_tel"] = self.buyerTel.text
        self.listFromInput["buyer_addr"] = self.buyerAddr.text
        self.listFromInput["buyer_postcode"] = self.buyerPostCode.text
        self.listFromInput["vbank_due"] = self.vbankDue.text
        self.listFromInput["app_scheme"] = self.appScheme.text
        self.listFromInput["m_redirect_url"] = self.mRedirectUrl.text

    }
    
}
