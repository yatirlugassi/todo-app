import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Factory constructor to create a UserModel from a Supabase User
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      isVerified: user.emailConfirmedAt != null,
      createdAt: user.createdAt,
    );
  }
}