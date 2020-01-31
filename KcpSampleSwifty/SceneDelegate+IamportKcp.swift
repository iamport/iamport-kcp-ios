//
//  SceneDelegate+IamportKcp.swift
//  KcpSampleSwift
//
//  Created by iamport on 22/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

extension SceneDelegate {
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //외부 APP에서 AppScheme(MY_APP_SCHEME):// 을 보내 테스트할 App실행 시 ISP를 체크해준다.
        guard let url = URLContexts.first?.url else{ return }
        url.checkReturnFromIsp(url)
        
    }
}
