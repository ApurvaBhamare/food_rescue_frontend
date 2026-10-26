
import 'package:flutter/material.dart';
import 'my_claimed_food_screen.dart';
import 'available_food_screen.dart';
import '../model/user_model.dart';

class NgoDashboard extends StatelessWidget {

  final UserModel user;
  const NgoDashboard({super.key,required this.user,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NGO Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Text(
              'Welcome, NGO!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvailableFoodScreen(
          user: user,
        ),
      ),
    );
  },
  icon: Icon(Icons.restaurant),
  label:Text('Available Food'),
),
            SizedBox(height: 12),

ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyClaimedFoodScreen(
          user: user,
        ),
      ),
    );
  },
  icon: const Icon(Icons.volunteer_activism),
  label: const Text('My Claimed Food'),
),
          ],
        ),
      ),
    );
  }
}
