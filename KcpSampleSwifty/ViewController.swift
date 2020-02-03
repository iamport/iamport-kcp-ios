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
    
    @IBOutlet var myWebView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Native(HTML) -> WKWebView로 데이터를 전달하기 위함
        let contentController = WKUserContentController()
        contentController.add(self, name: "iamportTest")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        myWebView = WKWebView(frame: view.frame, configuration: configuration)
        self.view.addSubview(myWebView)
        
        self.myWebView.navigationDelegate = self
        self.myWebView.uiDelegate = self
        
        //open in demo webpage
        //loadWebPage(url : "https://www.iamport.kr/demo")
        
        //open in HTML source (무조건 존재!)
        let myHTMLBundle = Bundle.main.url(forResource: "IamportTest", withExtension: "html")!
        let myRequest = URLRequest(url: myHTMLBundle)
        myWebView.load(myRequest)
        
        //ios 13부터 ipad가 pc로서 동작하게 됨(user agent string), userAgent에 ipad를 추가 ,추후 변경가능할듯
        myWebView.evaluateJavaScript("navigator.userAgent") {
            
            [weak myWebView] (result, error) in
            if let webView = myWebView, let userAgent = result as? String {
                
                webView.customUserAgent = userAgent + "iPad"
        
            }
            
        }
    
        
    }
    
    func loadWebPage(url: String) {
        
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
        
    }
    
    
}

// MARK: - IAMPORT KCP transfer info in HTML TO WKVIEW

extension ViewController: WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //script로부터 들어오는 data 구현부
        print("구현해주세요")
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




