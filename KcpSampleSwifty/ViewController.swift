//
//  ViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController ,WKUIDelegate {
    
    @IBOutlet weak var myWebView: WKWebView!
    
    func loadWebPage(url: String) {
        
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //fortest
        
        
        self.myWebView.navigationDelegate = self
        self.myWebView.uiDelegate = self
        
        //open in demo webpage
        //loadWebPage(url : "https://www.iamport.kr/demo")
        
        //open in HTML source
        let myHTMLBundle = Bundle.main.url(forResource: "IamportTest", withExtension: "html")!
        let myRequest = URLRequest(url: myHTMLBundle)
        myWebView.load(myRequest)
        
    }
}

// MARK: - IAMPORT KCP WEBVIEW TO CHECK ISP AND URL FROM OTHER REQUEST

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let request = navigationAction.request
        guard let url = request.url else { return }
        
        // decisionHandler 중복호출을 피하기위해 closure 작성하여 policy를 도출
        let navigationPolicyBasedOnUrlScheme = { () -> WKNavigationActionPolicy in
            //HTML로 실행했을 시 file:// scheme에 대한 권한부여 위함
            if url.scheme == "file" {
                print("webview에 요청된 url==> \(url.absoluteString)")
                return .allow
            }
            //APP STORE URL 경우 openURL 함수를 통해 앱스토어 어플을 활성화
            if url.isAppStoreUrl {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil) //?
                return .cancel
            }
            
            // URL scheme이 ISP를 요구 시 App존재여부 확인 후 Open/Download
            if url.needsIspAuthentication {
                let appURL = URL(string: url.absoluteString)
                if UIApplication.shared.canOpenURL(appURL!) {
                    print("mobile isp checked")
                    UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                    //debug용
                     print("webview에 요청된 url==> \(url.absoluteString)")
                    
                    return .allow
                } else {
                    //alert
                    self.showAlertViewWithEvent("모바일 ISP가 설치되어 있지 않아 \n App Store로 이동합니다.", tagNum: 99)
                    
                    return .cancel
                }
            }

            print("webview에 요청된 url==> \(url.absoluteString)")
            
            //기타(금결원 실시간계좌이체 등) http scheme이 들어왔을 경우 URL을 Open하기 위함
            if !url.isHttpOrHttps {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
                return .cancel
            }
            return .allow
        }
        
        decisionHandler(
            navigationPolicyBasedOnUrlScheme())
    }
    
}

// MARK: - IAMPORT KCP ALERT TO OPEN ISP DOWNLOAD URL FROM APP STORE

extension ViewController: UIAlertViewDelegate {

    func showAlertViewWithEvent(_ msg : String, tagNum tag : Int) {
        
        let alert : UIAlertController = UIAlertController(title: "알림", message: "_msg", preferredStyle: .alert)
        
        alert.view.tag = tag
        
        let okAction = UIAlertAction(title :"확인",style: .default, handler: {
            ACTION in
            if alert.view.tag == 99 {
              let URLstring : String = "https://itunes.apple.com/app/mobail-gyeolje-isp/id369125087?mt=8"
                let storeURL : URL = URL(string: URLstring)!
                UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
            }
        })
        
        alert.addAction(okAction)
        alert.present(alert, animated: true, completion: nil)
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "test", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {
         _ in completionHandler()
        })
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }

    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: "test", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            _ in completionHandler(false)
        })
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {
            _ in completionHandler(true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}




