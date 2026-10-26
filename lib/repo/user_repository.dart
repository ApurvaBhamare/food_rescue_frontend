
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const/api_constants.dart';
import '../model/user_model.dart';

class UserRepository {
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

  Future<bool> register(
  String name,
  String email,
  String password,
  String role,
) async {
  final response = await http.post(
    Uri.parse(ApiConstants.registerUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    if (data['success'] == true) {
      return true;
    }
  }

  throw Exception(data['message'] ?? 'Registration failed');
}
}
