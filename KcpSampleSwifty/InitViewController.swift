//
//  InitViewController.swift
//  KcpSampleSwift
//
//  Created by iamport on 14/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit


class InitViewController : UIViewController{
    
    @IBOutlet weak var pg: UITextField!
    @IBOutlet weak var payMethod: UITextField!
    @IBOutlet weak var merchantUid: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var buyerEmail: UITextField!
    @IBOutlet weak var buyerName: UITextField!
    @IBOutlet weak var buyerTel: UITextField!
    @IBOutlet weak var buyerAddr: UITextField!
    @IBOutlet weak var buyerPostCode: UITextField!
    @IBOutlet weak var vbankDue: UITextField!
    @IBOutlet weak var appScheme: UITextField!
    @IBOutlet weak var mRedirectUrl: UITextField!
    
    var listFromInput = [String: Any]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setBasicInput()
        
    }
    
    @IBAction func sendJSON(_ sender: UIButton) {
        performSegue(withIdentifier: "ToWebView", sender: self)
    }
    
    func setBasicInput() {
        self.pg.text = "kcp"
        self.payMethod.text = "card"
        self.merchantUid.text = "ORD20202020 -00000127"
        self.name.text = "노르웨이 고등어"
        self.amount.text = "1000"
        self.buyerEmail.text = "gildong@gmail.com"
        self.buyerName.text = "홍길동"
        self.buyerTel.text = "010-2020-2020"
        self.buyerAddr.text = "서울특별시 강남구 신사동"
        self.buyerPostCode.text = "01181"
        self.vbankDue.text = "20200220"
        self.appScheme.text = "iamporttest"
        self.mRedirectUrl.text = "https://www.iamport.kr/"
    }
    
}
