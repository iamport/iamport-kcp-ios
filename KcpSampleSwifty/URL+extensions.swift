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

}
