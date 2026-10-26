
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../repo/food_repository.dart';

class MyAddedFoodScreen extends StatefulWidget {
  final UserModel user;

  const MyAddedFoodScreen({
    super.key,
    required this.user,
  });

  @override
  State<MyAddedFoodScreen> createState() =>
      _MyAddedFoodScreenState();
}

class _MyAddedFoodScreenState extends State<MyAddedFoodScreen> {
  final FoodRepository repository = FoodRepository();

  late Future<List<dynamic>> foodFuture;

  @override
  void initState() {
    super.initState();
    foodFuture = repository.getMyAddedFood(
      token: widget.user.token,
    );
  }

  Future<void> refreshFood() async {
    final future = repository.getMyAddedFood(
      token: widget.user.token,
    );

    setState(() {
      foodFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF176B4D);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      appBar: AppBar(
        title: const Text('My Food Listings'),
        backgroundColor: const Color(0xFFF6F8F5),
        foregroundColor: green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: foodFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: green),
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
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text('Could not load food: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodFuture = repository.getMyAddedFood(
                            token: widget.user.token,
                          );
                        });
                      },
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
                    Icons.no_food_rounded,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No food listings yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text('Pull down to refresh'),
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
                final food = Map<String, dynamic>.from(
                  foods[index] as Map,
                );

                final name = food['food_name']?.toString() ?? 'Food';
                final quantity = food['quantity']?.toString() ?? '-';
                final description =
                    food['description']?.toString() ?? '';
                final expiry =
                    food['expiry_time']?.toString() ?? '';

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFE5F3E9),
                              child: Icon(
                                Icons.restaurant,
                                color: green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Quantity: $quantity'),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(description),
                        ],
                        if (expiry.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Expiry: $expiry'),
                        ],
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
