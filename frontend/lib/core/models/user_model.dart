/// User model representing the logged-in user
class UserModel {
  final String id;
  final String? email;
  final bool? isVerified;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    this.email,
    this.isVerified,
    this.createdAt,
  });

  /// Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      isVerified: json['is_verified'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}