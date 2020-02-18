//
//  KcpWebViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit



class KcpWebViewController: UIViewController{
    
    @IBOutlet var webView: WKWebView!

    // URL을 통해 받아오는 & bundle로 사용되어질 HTML의 이름을 작성합니다.
    let yourHTMLName : String = "IamportTest"//.html
    
    // didFinish 옵션을 한번만 사용하게 하기 위해서 method가 불렸는지를 확인하기위한 flag
    var isLoaded : Bool = false
    
    var listFromInputPage = [String: Any]()
    var listFromKcpMain = [String: Any]()
    
    var mRedirectUrlValue : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Javascript <-> swift 코드간의 bridge를 설정하기 위한 setup
        setupMessageHandler(yourHTMLName)
        
        // ios13 이 후 변경된 ipad의 user agent string을 mobile로 설정해주기 위해 필요
        // ipad가 웹결제로 진행된다면 오류가 생길 수 있습니다.
        overrideUserAgent()
        
        // WKWebView의 인앱결제 종료 시 WebView를 종료하기 위해 존재하는 NotificationCenter를 setup합니다.
        setEndNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    
        //설정한 m_redirect_url의 도착을 확인하면 종료를 확인 할 수 있으니 미리 input으로 받아온 값을 전역변수로 저장합니다.
        getRedirectURLFromInput()
        
        // 번들에 들어있는 html코드의 file url을 가져오게됩니다.
        // let htmlResourceUrl = URL(string: "https://iamport.kr/....") <- 실제 URL
        let htmlResourceUrl = Bundle.main.url(forResource: yourHTMLName, withExtension: "html")!
        let timeoutInterval = 1
        
        // url을 이용해서 load할 시에는 cache를 사용하고 html이 도착하지 않았을 경우를 대비하여 timeout에 여유를 두는걸 권합니다.
        // let timeoutInterval = 10
        
        let request: URLRequest = URLRequest.init(url: htmlResourceUrl, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval(timeoutInterval))

        self.webView.load(request)
        
    }
    
}
