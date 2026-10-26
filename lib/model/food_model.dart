
class FoodModel {
  final int? id;
  final String foodName;
  final int quantity;
  final String description;
  final String expiryTime;
  final String status;

  FoodModel({
    this.id,
    required this.foodName,
    required this.quantity,
    required this.description,
    required this.expiryTime,
    required this.status,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse('${json['id']}'),
      foodName: json['food_name']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse('${json['quantity']}') ?? 0,
      description: json['description']?.toString() ?? '',
      expiryTime: json['expiry_time']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Available',
    );
  }
}
