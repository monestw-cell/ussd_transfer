import 'package:flutter/material.dart';
  import 'package:permission_handler/permission_handler.dart';
  import 'screens/home_screen.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await [Permission.phone, Permission.contacts].request();
    runApp(const UssdTransferApp());
  }

  class UssdTransferApp extends StatelessWidget {
    const UssdTransferApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'USSD TRANSFER',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5F7A)),
          useMaterial3: true,
          fontFamily: 'sans-serif',
        ),
        home: const HomeScreen(),
      );
    }
  }
  