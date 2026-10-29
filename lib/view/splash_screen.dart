
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    // Change 'isLoggedIn' only if your app uses a different key.
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;


Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const RegisterScreen(),
  ),
);

    if (isLoggedIn) {
      
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.volunteer_activism_rounded,
              size: 90,
              color: green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Food Rescue',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Rescue Food. Share Hope.'),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: green),
          ],
        ),
      ),
    );
  }
}
