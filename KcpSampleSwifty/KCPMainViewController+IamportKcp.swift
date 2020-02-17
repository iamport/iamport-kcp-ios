//
//  KCPMainViewController+IamportKcp.swift
//  KcpSampleSwift
//
//  Created by Andy Park on 2020/02/05.
//  Copyright © 2020 iamport. All rights reserved.
//

import Foundation
import WebKit

// MARK: - IAMPORT KCP 기본 세팅 함수들
extension KCPMainViewController {

    
    //webview와 javascript 통신을 위해 setup
    func setupMessageHandler(_ yourHTMLName: String) {
        let config = WKWebViewConfiguration()
               let contentController = WKUserContentController()
               config.userContentController = contentController
               
               self.webView = WKWebView(frame: .zero, configuration: config)
               view = webView

               self.webView.navigationDelegate = self
               self.webView.uiDelegate = self
        
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
    
    func setEndNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(endWebView(_:)), name: Notification.Name("isOver"), object: nil)
    }
    
    func getRedirectURLFromInput() {
        mRedirectUrlValue = listFromInputPage["m_redirect_url"] as! String
    }
    
}

// MARK: - IAMPORT KCP 실행함수들

extension KCPMainViewController {
    
    @objc func endWebView(_ notification: Notification){
        self.webView.stopLoading()
        self.webView.removeFromSuperview()
        self.webView.navigationDelegate = nil
        self.webView = nil
    }
    
    //segue 변경용
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEndPage" {
            let toEndPage = segue.destination as! EndPageViewController
            toEndPage.endList = listFromKcpMain
        }
    }
    
    func loadWebPage(url: String) {
          
          let myUrl = URL(string: url)
          let request = URLRequest(url: myUrl!)
          self.webView.load(request)
      }
    
    func loadHTML(_ yourHTMLName: String) {
          let htmlResourceUrl = Bundle.main.url(forResource: yourHTMLName, withExtension: "html")!
          let myRequest = URLRequest(url: htmlResourceUrl)  // RENAME
          self.webView.load(myRequest)
      }
}

// MARK: - IAMPORT KCP HTML Form 입력값을 WKWebView로 값을 전달하기 위한 Message Handler

extension KCPMainViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //java script로부터 들어오는 data 구현부

        if message.name == "iamportTest" {
            
            
        }
    }
}

// MARK: - IAMPORT KCP 최종 등록 완료 웹페이지, 결제 오류 페이지에서 alert(), confilm() 함수에 대한 처리
extension KCPMainViewController: WKUIDelegate {
    
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

// MARK: - IAMPORT KCP ISP체크와 WKWebView에 들어오는 URL Request를 처리

extension KCPMainViewController: WKNavigationDelegate {
    
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
            
            let queryComponents = URLComponents(string: url.absoluteString)
            let queryItems = queryComponents?.queryItems
            
            for item in queryItems! {
                listFromKcpMain[item.name] = item.value
            }
    
            performSegue(withIdentifier: "ToEndPage", sender: self)
            NotificationCenter.default.post(name: Notification.Name("isOver"), object: nil)
            
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
                url.showAlertViewWithEvent("모바일 ISP가 설치되어 있지 않아 \n App Store로 이동합니다.", tagNum: 99)
                return .cancel
            }
        }
    
        //기타(금결원 실시간계좌이체 등)
        if !url.isHttpOrHttps {
            print("webview에 요청된 url==> \(url.absoluteString)")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .cancel
        }
        
        print("webview에 요청된 url==> \(url.absoluteString)")

        return .allow
    }
    
    //html의 subresource까지 load완료 되었는지를 확인
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.isLoaded == false
        {
            let inputFromSwift = "request_pay(\(listFromInputPage.jsonStringRepresentation!))"
            print("aa")
            self.isLoaded = true
            self.webView.evaluateJavaScript(inputFromSwift, completionHandler: nil)
            
        }
    }
    
}

// MARK: - IAMPORT KCP ISP체크용 URL Extension
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

// MARK: - IAMPORT KCP 진행사항 체크용 URL Extension
extension URL {
    
    func isOver(_ mRedirectUrlValue : String) -> Bool {
        return self.absoluteString.hasPrefix(mRedirectUrlValue) && mRedirectUrlValue != ""
    }
    
}

// MARK: - Dictionary -> JSON
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .utf8)
    }
}






