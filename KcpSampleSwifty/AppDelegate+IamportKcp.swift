//
//  IamportKcp.swift
//  test
//
//  Created by iamport on 07/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//
import UIKit

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
       HTTPCookieStorage.shared.cookieAcceptPolicy = .always

        return true
    }
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use scene above iOS 13.0: instead.")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //Scene에서의 외부 URL 접근과 같은 기능이나 iOS 13.0 아래에서 기능하기 위함
        url.checkReturnFromIsp(url)
        
        return true
    }
}
