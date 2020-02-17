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
        if segue.identifier == "ToWebView" {
            let toKCPMain = segue.destination as! KCPMainViewController
            toKCPMain.listFromInputPage = list
        }
    }
    
}
