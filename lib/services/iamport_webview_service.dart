import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../config/app_config.dart';

class IamportWebViewService {
  static Future<Map<String, dynamic>?> showPaymentWebView({
    required BuildContext context,
    required String merchantUid,
    required int amount,
    required String customerName,
    required String customerPhone,
    String? channelKey,
  }) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => IamportPaymentWebView(
          merchantUid: merchantUid,
          amount: amount,
          customerName: customerName,
          customerPhone: customerPhone,
          channelKey: channelKey ?? AppConfig.inisisChannelKey,
        ),
      ),
    );

    return result;
  }
}

class IamportPaymentWebView extends StatefulWidget {
  final String merchantUid;
  final int amount;
  final String customerName;
  final String customerPhone;
  final String channelKey;

  const IamportPaymentWebView({
    super.key,
    required this.merchantUid,
    required this.amount,
    required this.customerName,
    required this.customerPhone,
    required this.channelKey,
  });

  @override
  State<IamportPaymentWebView> createState() => _IamportPaymentWebViewState();
}

class _IamportPaymentWebViewState extends State<IamportPaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });

            // Iamport 결제 페이지 로드 후 결제 요청
            if (url.contains('iamport.kr') || url.contains('iamport')) {
              _requestPayment();
            }

            // 결제 완료 URL 체크
            if (url.contains('payment/success') || url.contains('success')) {
              _handlePaymentSuccess(url);
            } else if (url.contains('payment/fail') || url.contains('fail')) {
              _handlePaymentFailure(url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            Navigator.of(context).pop({'success': false, 'error': error.description});
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.iamport.kr/mobile'));
  }

  void _requestPayment() {
    // Iamport v2 결제 요청 JavaScript
    final paymentScript = '''
      IMP.init('${widget.channelKey}');
      
      IMP.request_pay({
        pg: '${widget.channelKey.contains('kakao') ? 'kakaopay' : 'inicis'}',
        pay_method: 'card',
        merchant_uid: '${widget.merchantUid}',
        name: '레고 브릭 빌드업 예약',
        amount: ${widget.amount},
        buyer_name: '${widget.customerName}',
        buyer_tel: '${widget.customerPhone}',
      }, function(rsp) {
        if (rsp.success) {
          window.flutter_inappwebview.callHandler('paymentSuccess', rsp);
        } else {
          window.flutter_inappwebview.callHandler('paymentFail', rsp);
        }
      });
    ''';

    _controller.runJavaScript(paymentScript);
  }

  void _handlePaymentSuccess(String url) {
    // URL에서 결제 정보 추출
    final uri = Uri.parse(url);
    final impUid = uri.queryParameters['imp_uid'];
    final merchantUid = uri.queryParameters['merchant_uid'];

    Navigator.of(context).pop({
      'success': true,
      'imp_uid': impUid,
      'merchant_uid': merchantUid ?? widget.merchantUid,
    });
  }

  void _handlePaymentFailure(String url) {
    Navigator.of(context).pop({
      'success': false,
      'error': '결제가 취소되었습니다.',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop({'success': false, 'cancelled': true}),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
