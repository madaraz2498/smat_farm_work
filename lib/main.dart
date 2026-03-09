import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/screens/login_screen.dart';


void main() {
  runApp(
    // AuthProvider lives at the very top so every widget in the tree
    // can read auth state via context.read<AuthProvider>() or
    // context.watch<AuthProvider>().
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farm AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAFBF7),
      ),
      home: const LoginScreen(),
    );
  }
}
