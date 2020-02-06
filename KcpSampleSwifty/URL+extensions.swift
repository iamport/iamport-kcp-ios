//
//  CheckReturnFromISP.swift
//  KcpSampleSwift
//
//  Created by iamport on 22/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

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
    
    var makeJSONFromUrlQuery : String? {
        let queryComponents = URLComponents(string: self.absoluteString)
        let queryItems = queryComponents?.queryItems
        
        //Dictianary변환
        var messageDictionary = [String: Any]()
        
        for item in queryItems! {
            messageDictionary[item.name] = item.value
        }
        
        return messageDictionary.jsonStringRepresentation
    }
}

// MARK: - Dictionary 형식을 JSON형식으로 변환하기 위한 Extension

extension Dictionary {
    
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .utf8)
    }
}
