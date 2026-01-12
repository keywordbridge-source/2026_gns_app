import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class IamportService {
  static const String baseUrl = 'https://api.iamport.kr';
  
  // Test mode - 실제 구현 시 환경에 따라 변경
  static const bool isTestMode = true;

  static Future<Map<String, dynamic>> requestPayment({
    required String merchantUid,
    required int amount,
    required String customerName,
    required String customerPhone,
    String? channelKey,
  }) async {
    try {
      // Iamport v2 API 호출
      // 실제 구현 시 Iamport SDK 또는 REST API 사용
      // 여기서는 기본 구조만 제공
      
      final response = await http.post(
        Uri.parse('$baseUrl/payments/prepare'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'merchant_uid': merchantUid,
          'amount': amount,
          'channel_key': channelKey ?? AppConfig.inisisChannelKey,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Payment request failed');
      }
    } catch (e) {
      print('Error requesting payment: $e');
      rethrow;
    }
  }

  static Future<bool> verifyPayment(String impUid, String merchantUid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/$impUid'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response']['merchant_uid'] == merchantUid &&
            data['response']['status'] == 'paid';
      }
      return false;
    } catch (e) {
      print('Error verifying payment: $e');
      return false;
    }
  }
}
