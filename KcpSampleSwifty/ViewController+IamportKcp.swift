//
//  ViewController+IamportKcp.swift
//  KcpSampleSwift
//
//  Created by Andy Park on 2020/02/05.
//  Copyright © 2020 iamport. All rights reserved.
//

import Foundation
import WebKit

// MARK: - IAMPORT KCP Preparation
extension ViewController {

    // confirmation이란? m_redirect_url을 비교 후 WKWebView가 종료됨을 뜻한다.
    func setupConfirmationMessageHandler() {
        // Native(HTML) -> WKWebView로 데이터를 전달하기 위함
        let contentController = WKUserContentController()
        contentController.add(self, name: "iamportTest")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        self.webView = WKWebView(frame: self.view.frame, configuration: configuration)
        self.view.addSubview(self.webView)
    }
    
    func loadTestHtml() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        //데모 웹페이지로 열기
        //loadWebPage(url : "https://www.iamport.kr/demo")
        
        //Bundle의 html파일 열기
        let htmlResourceUrl = Bundle.main.url(forResource: "IamportTest", withExtension: "html")!
        let myRequest = URLRequest(url: htmlResourceUrl)  // RENAME
        self.webView.load(myRequest)
    }
    
    func overrideUserAgent() {
        //ios 13부터 ipad가 pc로서 동작하게 됨(user agent string problem), userAgent에 iPad를 추가 ,추후 변경가능할듯
        self.webView.evaluateJavaScript("navigator.userAgent") {
            
            [unowned self] (result, error) in
            if let userAgent = result as? String {
                self.webView.customUserAgent = userAgent + "iPad"
            }
        }
    }
    

    func loadWebPage(url: String) {
        
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        self.webView.load(myRequest)
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
        if url.isFileURL {
            
            print("webview에 요청된 url==> \(url.absoluteString)")
            return .allow
            
        }
        
        //HTML로 부터 받아온 요청한 m_redirect_url과 비교 후 같을 시 WKWebView를 종료하고 Query값을 이용가능함!
        if url.isOver(mRedirectUrlValue) {
            
            print("webview에 요청된 url==> \(url.absoluteString)")
            
            self.webView.stopLoading()
            self.webView.removeFromSuperview()
            self.webView.navigationDelegate = nil
            self.webView = nil
            
            self.dismiss(animated: true, completion: nil)
            
            //m_redirect_url로 Open
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            return .cancel
        }
        
        //APP STORE URL 경우 앱스토어 어플을 활성화
        if url.isAppStoreUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil) 
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
    
        //기타(금결원 실시간계좌이체 등) http & https scheme이 들어왔을 경우 URL을 Open하기 위함
        if !url.isHttpOrHttps {
            print("webview에 요청된 url==> \(url.absoluteString)")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .cancel
        }
        
        return .allow
    }
    
}

// MARK: - IAMPORT KCP ISP 앱 존재 여부 확인 후 미설치시 앱스토어를 열어줍니다.

extension ViewController {

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
}

// MARK: - IAMPORT KCP 최종 등록 완료 웹페이지, 결제 오류 페이지에서 alert(), confilm() 함수에 대한 처리
extension ViewController: WKUIDelegate {
    
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

// MARK: - IAMPORT KCP ISP 체크용 URL
extension URL {
    
    var needsIspAuthentication: Bool {
        return self.absoluteString.hasPrefix("ispmobile://")
    }
    
      
    func checkReturnFromIsp(_ url : URL) -> Void {
    
        if url.scheme == nil { return }
        if url.query == nil { return }
        
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
    
    func isOver(_ mRedirectUrlValue : String) -> Bool {
        return self.absoluteString.hasPrefix(mRedirectUrlValue) && mRedirectUrlValue != ""
    }
    
}






