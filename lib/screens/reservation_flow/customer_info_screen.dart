import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/reservation_provider.dart';
import '../../config/app_config.dart';

class CustomerInfoScreen extends ConsumerStatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  ConsumerState<CustomerInfoScreen> createState() =>
      _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends ConsumerState<CustomerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPhoneVerified = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateKoreanName(String name) {
    final koreanRegex = RegExp(r'^[가-힣]+$');
    return koreanRegex.hasMatch(name) && name.length <= AppConfig.maxCustomerNameLength;
  }

  Future<void> _verifyPhone() async {
    // TODO: 실제 전화번호 인증 구현
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        _isPhoneVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증이 완료되었습니다.')),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _isPhoneVerified) {
      ref.read(reservationProvider.notifier).setCustomerInfo(
            _nameController.text,
            _phoneController.text,
            _passwordController.text,
          );
      context.push('/payment');
    } else if (!_isPhoneVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('휴대전화 인증을 완료해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약자 정보')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '예약자 이름 (한글 5자 이내)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                if (!_validateKoreanName(value)) {
                  return '한글로 5자 이내로 입력해주세요.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: '휴대전화번호',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '휴대전화번호를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _verifyPhone,
                  child: const Text('인증'),
                ),
              ],
            ),
            if (_isPhoneVerified)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '✓ 인증 완료',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호 (4자리)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: AppConfig.customerPasswordLength,
              obscureText: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요.';
                }
                if (value.length != AppConfig.customerPasswordLength) {
                  return '4자리 숫자를 입력해주세요.';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('다음', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
