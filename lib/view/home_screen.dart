import 'package:flutter/material.dart';

import '../model/food_model.dart';
import '../repo/food_repository.dart';
import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FoodRepository repository = FoodRepository();

  late Future<List<FoodModel>> foodList;

  @override
  void initState() {
    super.initState();
    foodList = repository.getAvailableFood(token: widget.user.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Food')),
      body: FutureBuilder<List<FoodModel>>(
        future: foodList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Food load hot nahi. Backend check kar.'),
            );
          }

          final foods = snapshot.data ?? [];

          if (foods.isEmpty) {
            return const Center(child: Text('Available food nahi.'));
          }

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];

              return Card(
                child: ListTile(
                  title: Text(food.foodName),
                  subtitle: Text('Quantity: ${food.quantity}'),
                  trailing: Text(food.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
