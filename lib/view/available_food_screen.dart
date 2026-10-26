
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../model/food_model.dart';
import '../repo/food_repository.dart';

class AvailableFoodScreen extends StatefulWidget {
  final UserModel user;

  const AvailableFoodScreen({
    super.key,
    required this.user,
  });

  @override
  State<AvailableFoodScreen> createState() =>
      _AvailableFoodScreenState();
}

class _AvailableFoodScreenState
    extends State<AvailableFoodScreen> {
  final FoodRepository repository = FoodRepository();

  late Future<List<FoodModel>> foodFuture;

  @override
  void initState() {
    super.initState();
    foodFuture = repository.getAvailableFood(
      token: widget.user.token,
    );
  }

  Future<void> refreshFood() async {
    setState(() {
      foodFuture = repository.getAvailableFood(
        token: widget.user.token,
      );
    });

    try {
      await foodFuture;
    } catch (_) {
      // Error is shown by FutureBuilder.
    }
  }

  Future<void> claimFood(FoodModel food) async {
    if (food.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food ID is missing')),
      );
      return;
    }

    try {
      await repository.claimFood(
        token: widget.user.token,
        foodId: food.id!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food claimed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      await refreshFood();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        title: const Text('Available Food'),
        backgroundColor: const Color(0xFF247A45),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<FoodModel>>(
        future: foodFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Could not load food:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: refreshFood,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final foods = snapshot.data ?? [];

          if (foods.isEmpty) {
            return RefreshIndicator(
              onRefresh: refreshFood,
              child: ListView(
                children: const [
                  SizedBox(height: 140),
                  Icon(
                    Icons.restaurant,
                    size: 65,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text('No available food found'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshFood,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.foodName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Quantity: ${food.quantity}'),
                        const SizedBox(height: 6),
                        Text(
                          'Description: ${food.description.isEmpty ? "No description" : food.description}',
                        ),
                        const SizedBox(height: 6),
                        Text('Expiry: ${food.expiryTime}'),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => claimFood(food),
                            child: const Text('Claim Food'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
