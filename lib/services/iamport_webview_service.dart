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
      ..addJavaScriptChannel(
        'PaymentResult',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = message.message;
            if (data.contains('success')) {
              _handlePaymentSuccessFromJS(data);
            } else {
              _handlePaymentFailureFromJS(data);
            }
          } catch (e) {
            print('Payment result parsing error: $e');
          }
        },
      )
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

            // Iamport SDK 로드 후 결제 요청
            _loadIamportSDK();
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              Navigator.of(context).pop({
                'success': false,
                'error': error.description,
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('data:text/html;charset=utf-8,${Uri.encodeComponent(_getPaymentHTML())}'));
  }

  String _getPaymentHTML() {
    final pg = widget.channelKey.contains('kakao') ? 'kakaopay' : 'inicis';
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>결제</title>
  <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
</head>
<body>
  <div id="payment-container" style="padding: 20px;">
    <h2>레고 브릭 빌드업 예약 결제</h2>
    <p>결제 금액: ${widget.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원</p>
    <button id="pay-button" style="padding: 15px 30px; font-size: 16px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer;">
      결제하기
    </button>
  </div>
  
  <script>
    IMP.init('${widget.channelKey}');
    
    document.getElementById('pay-button').addEventListener('click', function() {
      IMP.request_pay({
        pg: '$pg',
        pay_method: 'card',
        merchant_uid: '${widget.merchantUid}',
        name: '레고 브릭 빌드업 예약',
        amount: ${widget.amount},
        buyer_name: '${widget.customerName}',
        buyer_tel: '${widget.customerPhone}',
      }, function(rsp) {
        if (rsp.success) {
          PaymentResult.postMessage(JSON.stringify({
            success: true,
            imp_uid: rsp.imp_uid,
            merchant_uid: rsp.merchant_uid,
            paid_amount: rsp.paid_amount
          }));
        } else {
          PaymentResult.postMessage(JSON.stringify({
            success: false,
            error: rsp.error_msg || '결제에 실패했습니다.'
          }));
        }
      });
    });
  </script>
</body>
</html>
    ''';
  }

  void _loadIamportSDK() {
    // SDK는 HTML에 이미 포함되어 있음
  }

  void _handlePaymentSuccessFromJS(String data) {
    try {
      // JSON 파싱 (간단한 형태)
      final impUid = data.contains('imp_uid') 
          ? data.split('imp_uid')[1].split('"')[2] 
          : widget.merchantUid;
      
      if (mounted) {
        Navigator.of(context).pop({
          'success': true,
          'imp_uid': impUid,
          'merchant_uid': widget.merchantUid,
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop({
          'success': true,
          'imp_uid': widget.merchantUid,
          'merchant_uid': widget.merchantUid,
        });
      }
    }
  }

  void _handlePaymentFailureFromJS(String data) {
    final error = data.contains('error') 
        ? data.split('error')[1].split('"')[2] 
        : '결제에 실패했습니다.';
    
    if (mounted) {
      Navigator.of(context).pop({
        'success': false,
        'error': error,
      });
    }
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
