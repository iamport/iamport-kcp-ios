# Kcp-iOS-SwiftSample

Swift 언어로 작성된 KCP 결제연동 샘플입니다.

이 샘플은 App(native) ->WKWebView -> App(native)의 시나리오로 동작합니다.
이해를 돕기위해 3개의 ViewController로 동작하며 결제프로세스가 진행되는 동안만 WKWebView가 동작하게 됩니다.  

아임포트 결제연동은 [[아임포트 결제연동 매뉴얼]](https://docs.iamport.kr/)을 참고해 주시기 바랍니다.

## 아임포트 라이브러리 추가하기 
최상단 HTML(/yours.html)에 아래의 script를 삽입합니다. 아임포트 라이브러리는 jQuery 기반으로 동작하기 때문에 jQuery 1.0 이상이 반드시 설치되어 있어야합니다. 이 Sample Code에서 jQuery는 static asset으로 저장되어 있습니다.

~~~
    <!-- jQuery -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>

    <!-- jQueryInThisSample -->
    <script type="text/javascript" src="jquery-1.12.4.min.js" ></script>

    <!-- iamport.payment.js -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.7.js"></script>
~~~
~~~
    var IMP = window.IMP; //자세한 사항은 https://docs.iamport.kr/implementation/payment 확인해주세요.
    IMP.init("imp________"); // Iamport dashboard의 고유 가맹점 식별코드를 확인하여 변경해야 합니다.
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

위의 카드 이용 시 ISP체크를 위해 외부 앱으로 이동 후 인증은 서버 외부단에서 동작하며,
ISP 인증에 대한 여부는 입력한 APP_Scheme으로 확인이 가능합니다. 외부 앱 이동 후 복귀를 위해 *info.plist*의 URL Scheme값에 app_scheme을 등록해주십시오.

## 결제 이 후
**모바일**의 경우 웹과는 다르게 Java script의 call back함수로 동작하지 않습니다. 그래서 설정한 m_redirect_url에 추가적인 정보가 Query로 붙어 동작하게 됩니다.

    http://www.redirected.com/?u_id=1&m_id=2...
    
이 샘플은 앱으로 다시 돌아오게 설정되어 있기 때문에 redirect url에 대해서 별도로 처리되어야합니다.   
