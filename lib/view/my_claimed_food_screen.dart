
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../model/food_model.dart';
import '../repo/food_repository.dart';

class MyClaimedFoodScreen extends StatefulWidget {
  final UserModel user;

  const MyClaimedFoodScreen({
    super.key,
    required this.user,
  });

  @override
  State<MyClaimedFoodScreen> createState() =>
      _MyClaimedFoodScreenState();
}

class _MyClaimedFoodScreenState
    extends State<MyClaimedFoodScreen> {
  final FoodRepository repository = FoodRepository();

  late Future<List<FoodModel>> claimedFoodFuture;

  @override
  void initState() {
    super.initState();
    loadClaimedFood();
  }

  void loadClaimedFood() {
    claimedFoodFuture = repository.getMyClaimedFood(
      token: widget.user.token,
    );
  }

  Future<void> refreshFood() async {
    setState(() {
      loadClaimedFood();
    });

    try {
      await claimedFoodFuture;
    } catch (_) {
      // FutureBuilder will display the error.
    }
  }

  Future<void> markAsPickedUp(FoodModel food) async {
    if (food.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food ID is missing'),
        ),
      );
      return;
    }

    try {
      await repository.pickupFood(
        token: widget.user.token,
        foodId: food.id!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food marked as picked up!'),
          backgroundColor: Colors.green,
        ),
      );

      await refreshFood();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        title: const Text(
          'My Claimed Food',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF247A45),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<FoodModel>>(
        future: claimedFoodFuture,
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
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
                  SizedBox(height: 150),
                  Icon(
                    Icons.volunteer_activism,
                    size: 70,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No claimed food yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Claim food from Available Food.',
                    ),
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
                  margin: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor:
                                  Color(0xFFE3F3E8),
                              child: Icon(
                                Icons.restaurant,
                                color: Color(0xFF247A45),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                food.foodName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Quantity: ${food.quantity}',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Description: ${food.description.isEmpty ? "No description" : food.description}',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Expiry: ${food.expiryTime}',
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                markAsPickedUp(food),
                            icon: const Icon(
                              Icons.check_circle_outline,
                            ),
                            label: const Text(
                              'Mark as Picked Up',
                            ),
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF247A45),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.all(14),
                            ),
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
