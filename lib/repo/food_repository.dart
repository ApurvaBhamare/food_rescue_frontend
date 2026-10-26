
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const/api_constants.dart';
import '../model/food_model.dart';

class FoodRepository {
  // Add food to backend
  Future<void> addFood({
    required String token,
    required String foodName,
    required String quantity,
    required String description,
    required DateTime expiryTime,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/food/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'food_name': foodName,
        'quantity': int.parse(
          quantity.trim().split(' ').first,
        ),
        'description': description,
        'expiry_time': expiryTime.toIso8601String(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] == false) {
      throw Exception(
        data['message'] ?? 'Failed to add food',
      );
    }
  }

  // Get available food from backend
  Future<List<FoodModel>> getAvailableFood({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse(ApiConstants.availableFoodUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      final List<dynamic> foodList = data['food'] as List<dynamic>;
return foodList
        .map((item) => FoodModel.fromJson(
              item as Map<String, dynamic>,
            ))
        .toList();
  }
    

    throw Exception(
      data['message'] ?? 'Failed to load available food',
    );
  }
  
Future<List<dynamic>> getMyAddedFood({
  required String token,
}) async {
  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/food/my-added'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode >= 200 &&
      response.statusCode < 300 &&
      data['success'] == true) {
    return data['food'] as List<dynamic>;
  }

  throw Exception(
    data['message'] ?? 'Failed to load your food listings',
  );
}

Future<void> claimFood({
  required String token,
  required int foodId,
}) async {
  final response = await http.patch(
    Uri.parse('${ApiConstants.baseUrl}/food/$foodId/claim'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode < 200 ||
      response.statusCode >= 300 ||
      data['success'] == false) {
    throw Exception(data['message'] ?? 'Failed to claim food');
  }
}
Future<List<FoodModel>> getMyClaimedFood({
  required String token,
}) async {
  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/food/my-claimed'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode >= 200 &&
      response.statusCode < 300) {
    final List<dynamic> foodList =
        data['food'] ?? [];

    return foodList
        .map((item) => FoodModel.fromJson(item))
        .toList();
  }

  throw Exception(
    data['message'] ?? 'Failed to load claimed food',
  );
}

Future<void> pickupFood({
  required String token,
  required int foodId,
}) async {
  final response = await http.patch(
    Uri.parse('${ApiConstants.baseUrl}/food/$foodId/pickup'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode < 200 ||
      response.statusCode >= 300 ||
      data['success'] == false) {
    throw Exception(
      data['message'] ?? 'Failed to update pickup status',
    );
  }
}
}
