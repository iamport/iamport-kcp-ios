//
//  CheckReturnFromISP.swift
//  KcpSampleSwift
//
//  Created by iamport on 22/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

    let MY_APP_SCHEME = "iamporttest"

extension URL {
    
    var needsIspAuthentication: Bool {
        return self.absoluteString.hasPrefix("ispmobile://")
    }
    
    var isHttpOrHttps: Bool {
        let strHttp: String = "http://"
        let strHttps: String = "https://"
        return self.absoluteString.hasPrefix(strHttp) || self.absoluteString.hasPrefix(strHttps)
    }
    
    var isAppStoreUrl: Bool {
        let bAppStoreURL : Bool = self.absoluteString.range(of: "phobos.apple.com") != nil
        let bAppStoreURL2 : Bool = self.absoluteString.range(of: "itunes.apple.com") != nil

        return bAppStoreURL || bAppStoreURL2
    }
    
    
    func checkReturnFromIsp(_ url : URL) -> Void {
  
       guard let scheme = url.scheme else {
           return
       }
       guard scheme.hasPrefix(MY_APP_SCHEME) else {
           return
       }
       if url.query == nil {
           return
       }
       //ISP 신용카드 인증 후 복귀하는 경우 app_scheme://card_pay?&approval_key=1U4o7afhafcialhfilsan.RSGsgm.fasdfasfas 5ei0000 와 같이 approval_key와 함께 리턴됩니다.
       // approval_key의 마지막 4자리는 ISP인증 결과가 성공이었는지를 나타내는 코드입니다.
       // 실제 카드결제 승인처리는 서버단에서 동작하므로 openURL이 실행된 시점과 승인이 완료되는 시점과는 무관합니다.
       // ISP인증이 잘 되었는지 로깅용으로 approval_key 마지막 4자리 추출
      
       let queryComponents = URLComponents(string: url.absoluteString)
       let queryItems = queryComponents?.queryItems
       guard let approval_key = queryItems?.filter({$0.name == "approval_key"}).first?.value else{ return }
      
       print("approval_key is \(approval_key)")
      
       let textStartIndex = approval_key.index(approval_key.endIndex, offsetBy: -4)
       let textEndIndex = approval_key.endIndex
      
       let resultCode = approval_key[textStartIndex ..< textEndIndex]
      
       print("resultCode is \(resultCode)")
      
       if resultCode.elementsEqual("0000") {
           print("ISP인증 성공")
       }
       else {
           print("ISP인증 실패 : \(resultCode)")
       }
    }
    
}
