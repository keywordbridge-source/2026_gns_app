import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'services/firebase_init_service.dart';
import 'screens/home_screen.dart';
import 'screens/reservation_flow/kit_selection_screen.dart';
import 'screens/reservation_flow/time_selection_screen.dart';
import 'screens/reservation_flow/date_time_selection_screen.dart';
import 'screens/reservation_flow/seat_selection_screen.dart';
import 'screens/reservation_flow/customer_info_screen.dart';
import 'screens/reservation_flow/payment_screen.dart';
import 'screens/my_reservation_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/admin/add_build_kit_screen.dart';
import 'screens/admin/batch_add_kits_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  try {
    await FirebaseInitService.initialize();
    await FirebaseInitService.initializeBuildKits();
  } catch (e) {
    print('Firebase 초기화 오류: $e');
    // Firebase 설정이 완료되지 않았을 수 있으므로 계속 진행
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '2026 GNS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/kit-selection',
      builder: (context, state) => const KitSelectionScreen(),
    ),
    GoRoute(
      path: '/time-selection',
      builder: (context, state) => const TimeSelectionScreen(),
    ),
    GoRoute(
      path: '/date-time-selection',
      builder: (context, state) => const DateTimeSelectionScreen(),
    ),
    GoRoute(
      path: '/seat-selection',
      builder: (context, state) => const SeatSelectionScreen(),
    ),
    GoRoute(
      path: '/customer-info',
      builder: (context, state) => const CustomerInfoScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/my-reservation',
      builder: (context, state) => const MyReservationScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
    ),
    GoRoute(
      path: '/admin/add-kit',
      builder: (context, state) => const AddBuildKitScreen(),
    ),
    GoRoute(
      path: '/admin/batch-add-kits',
      builder: (context, state) => const BatchAddKitsScreen(),
    ),
  ],
);
