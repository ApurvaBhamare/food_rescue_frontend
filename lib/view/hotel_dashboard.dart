
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'add_food_screen.dart';
import 'my_added_food_screen.dart';
import 'package:lottie/lottie.dart';


class HotelDashboard extends StatelessWidget {
  final UserModel user;

  const HotelDashboard({
    super.key,
    required this.user,
  });

  static const Color green = Color(0xFF176B4D);
  static const Color orange = Color(0xFFFF784F);
  static const Color background = Color(0xFFF6F8F5);

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.eco_rounded, color: green, size: 30),
            SizedBox(width: 8),
            Text(
              'FoodRescue',
              style: TextStyle(
                color: green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
       actions: [
  IconButton(
    onPressed: () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          Future.delayed(const Duration(seconds: 2), () {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          });

          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                height: 130,
                child: Lottie.asset(
                  'assets/succeess.json',
                  repeat: false,
                ),
              ),
            ),
          );
        },
      ).then((_) {
        if (context.mounted) {
          showMessage(context, 'You are logged in!');
        }
      });
    },
    icon: const Icon(Icons.notifications_none_rounded),
    color: green,
  ),
  const SizedBox(width: 8),
],),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${user.name} 👋',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20352C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Small actions. Big impact.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Main welcome banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [green, Color(0xFF32966B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.volunteer_activism_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Good food deserves.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'a second chance.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Share surplus food and help your community.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddFoodScreen(user: user),
                          ),
                        );
                      },
                      // icon: const Icon(Icons.add_circle_outline),
                      label: const Text(
                        'Donate Food',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                ' Impacts',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20352C),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      icon: Icons.restaurant_rounded,
                      title: 'Food Listings',
                      value: '—',
                      color: green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      icon: Icons.favorite_rounded,
                      title: 'Food Shared',
                      value: '—',
                      color: const Color.fromARGB(255, 223, 54, 3),
                    ),
                  ),
                ],
              ),

               SizedBox(height: 28),

              Text(
                'our works',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20352C),
                ),
              ),
            SizedBox(height: 14),

              _actionCard(
                context: context,
                icon: Icons.add_box_rounded,
                title: 'Add Surplus Food',
                subtitle: 'List extra food for donation',
                color: green,
               
onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFoodScreen(user: user),
                    ),
                  );
                },
              ),
               SizedBox(height: 12),
              _actionCard(
                context: context,
                icon: Icons.receipt_long_rounded,
                title: 'My Food Listings',
                subtitle: 'View food added by you',
                color: orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAddedFoodScreen(user: user),
                    ),
                  );
                },
              ),

           SizedBox(height: 26),

              Container(
                width: double.infinity,
                padding:  EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:  Color(0xFFE5F3E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: green,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Today’s reminder\nEvery meal shared can make a difference.',
                        style: TextStyle(
                          color: green,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE9EDE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
    SizedBox(height: 14),
          Text(
            value,
            style:  TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
 SizedBox(height: 5),
          Text(
            title,
            style:  TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _actionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding:  EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                padding:  EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                   SizedBox(height: 5),
                    Text(
                      subtitle,
                      style:  TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
        Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
