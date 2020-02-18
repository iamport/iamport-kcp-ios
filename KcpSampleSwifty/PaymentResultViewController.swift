//
//  EndPageViewController.swift
//  KcpSampleSwift
//
//  Created by iamport on 14/02/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

class PaymentResultViewController : UIViewController {
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var title4: UILabel!
    
    @IBOutlet weak var result1: UILabel!
    @IBOutlet weak var result2: UILabel!
    @IBOutlet weak var result3: UILabel!
    @IBOutlet weak var result4: UILabel!
    
    var endList = [String : Any]()
    
    override func viewWillAppear(_ animated: Bool) {
         print(endList)
        
        if endList.count == 4 {
            title1.text = "imp_uid"
            result1.text = endList["imp_uid"] as? String
            
            title2.text = "merchant_uid"
            result2.text = endList["merchant_uid"] as? String
            
            title3.text = "error_msg"
            result3.text = endList["error_msg"] as? String
      
            title4.text = "imp_success"
            result4.text = endList["imp_success"] as? String
        }
        else {
            title1.text = "imp_uid"
            result1.text = endList["imp_uid"] as? String
          
            title2.text = "merchant_uid"
            result2.text = endList["merchant_uid"] as? String
    
            title3.text = "imp_success"
            result3.text = endList["imp_success"] as? String
            
            title4.removeFromSuperview()
            result4.removeFromSuperview()
        }
    }
    
    
    
    
    
}
