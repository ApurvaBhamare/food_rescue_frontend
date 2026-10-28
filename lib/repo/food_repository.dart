import 'dart:convert';

import 'package:http/http.dart' as http;

import '../const/api_constants.dart';
import '../model/food_model.dart';

class FoodRepository {
  // Add food
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
        'quantity': int.parse(quantity.trim().split(' ').first),
        'description': description,
        'expiry_time': expiryTime.toIso8601String(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] == false) {
      throw Exception(data['message'] ?? 'Failed to add food');
    }
  }

  // Get available food
  Future<List<FoodModel>> getAvailableFood({required String token}) async {
    final response = await http.get(
      Uri.parse(ApiConstants.availableFoodUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      final List<dynamic> foodList = data['food'] as List<dynamic>;

      return foodList
          .map((item) => FoodModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(data['message'] ?? 'Failed to load available food');
  }

  // Get food added by current hotel
  Future<List<dynamic>> getMyAddedFood({required String token}) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/food/my-added'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      return data['food'] as List<dynamic>;
    }

    throw Exception(data['message'] ?? 'Failed to load your food listings');
  }

  // Claim food
  Future<void> claimFood({required String token, required int foodId}) async {
    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}/food/$foodId/claim'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] == false) {
      throw Exception(data['message'] ?? 'Failed to claim food');
    }
  }

  // Get food claimed by current NGO
  Future<List<FoodModel>> getMyClaimedFood({required String token}) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/food/my-claimed'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 &&
        response.statusCode >= 300 &&
        data['success'] == true) {
      final List<dynamic> foodList = data['food'] as List<dynamic>;

      return foodList
          .map((item) => FoodModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(data['message'] ?? 'Failed to load claimed food');
  }

  // Mark claimed food as picked up
  Future<void> pickupFood({required String token, required int foodId}) async {
    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}/food/$foodId/pickup'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] == false) {
      throw Exception(data['message'] ?? 'Failed to update pickup status');
    }
  }
}                                    
 