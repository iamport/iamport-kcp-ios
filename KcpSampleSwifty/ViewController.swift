//
//  ViewController.swift
//  test
//
//  Created by iamport on 06/01/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController
// FIXME
,WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    //HTML로 부터온 m_redirect_url
    var mRedirectUrlValue : String = ""

    //결제 완료 후 return되는 정보가 저장됩니다.
    //item.name : item.value
    //[imp_uid : imp_12341234]
    //[merchant_uid: ORD12341234-12341234]
    //[imp_success : true/false]
    //[errer_msg : error!!]
    var returnFromPaymentEndJSON : String? = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupConfirmationMessageHandler()
        loadTestHtml()
        overrideUserAgent()
    }

}

// MARK: - IAMPORT KCP HTML Form 입력값을 WKWebView로 값을 전달하기 위한 Message Handler

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //java script로부터 들어오는 data 구현부
        //HTML파일에서 입력한 m_redirect_url을 WKWebView의 전역변수로 넘겨준다.
        //m_redirect_url외의 값도 받아올 수 있음
        guard message.name == "iamportTest" else { return }
        
        guard let dictionary: [String : String] = message.body as? Dictionary else { return }
        if dictionary["m_redirect_url"] != nil {
            mRedirectUrlValue = dictionary["m_redirect_url"]!
        }
    }
}

// MARK: - IAMPORT KCP ISP체크와 WKWebView에 들어오는 URL Request를 처리

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else { return }
        
        decisionHandler(
            self.navigationPolicyBasedOnUrlScheme(url: url))
    }
    
    // decisionHandler 중복호출을 피하기위해 closure 작성하여 policy를 도출
    func navigationPolicyBasedOnUrlScheme(url: URL) -> WKNavigationActionPolicy {
        
        //HTML로 실행했을 시 실행할 파일 URL Scheme(file:// )에 대한 권한부여
        if url.scheme == "file" {
            
            print("webview에 요청된 url==> \(url.absoluteString)")
            return .allow
            
        }
        
        //HTML로 부터 받아온 요청한 m_redirect_url과 비교 후 같을 시 WKWebView를 종료하고 Query값을 이용가능함!
        if url.absoluteString.hasPrefix(self.mRedirectUrlValue) && self.mRedirectUrlValue != "" {
            
            print("webview에 요청된 url==> \(url.absoluteString)")
            
            self.webView.stopLoading()
            self.webView.removeFromSuperview()
            self.webView.navigationDelegate = nil
            self.webView = nil
            
            self.dismiss(animated: true, completion: nil)
            
            //Query값이 필요하면 ViewController의 전역으로 빼면 됨.
            let queryComponents = URLComponents(string: url.absoluteString)
            let queryItems = queryComponents?.queryItems
            
            //JSON 추출
            var messageDictionary = [String: Any]()
            
            for item in queryItems! {
                
                messageDictionary[item.name] = item.value
            }
            
            self.returnFromPaymentEndJSON = messageDictionary.jsonStringRepresentation

            print(self.returnFromPaymentEndJSON as Any)
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            return .cancel
        }
        
        //APP STORE URL 경우 앱스토어 어플을 활성화
        if url.isAppStoreUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil) //?
            return .cancel
        }
        
        // URL scheme이 ISP를 요구 시 App존재여부 확인 후 Open&Download
        if url.needsIspAuthentication {
            let appURL = URL(string: url.absoluteString)
            if UIApplication.shared.canOpenURL(appURL!) {
                UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                print("webview에 요청된 url==> \(url.absoluteString)")
                return .allow
            } else {
                self.showAlertViewWithEvent("모바일 ISP가 설치되어 있지 않아 \n App Store로 이동합니다.", tagNum: 99)
                return .cancel
            }
        }

        print("webview에 요청된 url==> \(url.absoluteString)")
        
        //기타(금결원 실시간계좌이체 등) http & https scheme이 들어왔을 경우 URL을 Open하기 위함
        if !url.isHttpOrHttps {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .cancel
        }
        
        return .allow
    }
    
}

// MARK: - IAMPORT KCP ISP 앱 존재 여부 확인 후 미설치시 앱스토어를 열어줍니다.

// FIXME
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
    
    //최종 등록이 완료되는 웹페이지에서 alert() confirm() 함수에 대한 처리
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





// MARK: - Dictionary 형식을 JSON형식으로 변환하기 위한 Extension

extension Dictionary {
    
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .utf8)
    }
}

