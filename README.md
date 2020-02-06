# Kcp-iOS-SwiftSample

Swift 언어로 작성된 KCP 결제연동 샘플입니다.

KCP 결제 프로세스가 시작되기 전까진 Bundle에 저장된 페이지를 기본으로 출력하고 WKWebView가 화면에 관여하지 않다가 결제 프로세스가 진행되는 동안에만 나타나게 됩니다. 

아임포트 결제연동은 [[아임포트 결제연동 매뉴얼]](https://docs.iamport.kr/)을 참고해 주시기 바랍니다.

## 아임포트 라이브러리 추가하기 
최상단 HTML(IamportTest.html)에 아래의 script를 삽입합니다. 아임포트 라이브러리는 jQuery 기반으로 동작하기 때문에 jQuery 1.0 이상이 반드시 설치되어 있어야합니다. 이 Sample Code에서 jQuery는 static asset으로 저장되어 있습니다. 
~~~
    <!-- jQuery -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>

    <!-- jQueryInThisSample -->
    <script type="text/javascript" src="jquery-1.12.4.min.js" ></script>

    <!-- iamport.payment.js -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.7.js"></script>
~~~


## ISP인증확인

    •	비씨카드
	◦	우리카드 
	◦	KDB 체크카드 
	◦	우체국 체크카드 
	◦	케이뱅크 체크카드 
	◦	신협 체크카드 
	◦	수협카드 
	◦	JB카드 
	◦	KJ카드 
	◦	제주VISA카드 
	◦	새마을금고 체크카드 
	◦	코나카드 
	◦	KB국민카드
	◦	카카오뱅크 카카오프렌즈 체크카드 - KB국민카드의 망을 이용한다.

위의 카드 이용 시 ISP체크를 위한 외부 앱 이동 후 인증은 서버 외부단에서 동작하며,
ISP 인증에 대한 여부는 입력한 APP_Scheme으로 확인이 가능합니다. 외부 앱 이동 후 복귀를 위해 *info.plist*의 URL Scheme값에 값을 지정해준 app_scheme을 등록해주십시오.

~~~
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //외부 APP에서 AppScheme(MY_APP_SCHEME):// 을 보내 테스트할 App실행 시 ISP를 체크해준다.
        guard let url = URLContexts.first?.url else{ return }
        url.checkReturnFromIsp(url)
        
    }
~~~

## 결제 후

WKWebView에서의 결제완료 시 Native View에서 보내 온 [***m_redirect_url***] 을 이용하여 결제 완료 시 결제사에서 보낸 url과 비교하여 종료를 확인힙니다. 

~~~
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
~~~
Message Handler를 통해 message로 들어온 JSON값을 WKWebView에서 이용하실 수 있습니다. 

WKWebView는 결제 완료와 동시에 종료되고 복귀하는 URL query를 JSON 으로 저장합니다.
~~~
    //결제 완료 후 return되는 정보가 저장됩니다.
    //item.name : item.value
    //[imp_uid : imp_12341234]
    //[merchant_uid: ORD12341234-12341234]
    //[imp_success : true/false]
    //[error_msg : error!!]
     var returnFromPaymentEndJSON : String? = ""
~~~

//TODO
