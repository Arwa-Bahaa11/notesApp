import 'package:notes/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String name,
    required String email,
    required String token,
  }) : super(id: id, name: name, email: email, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
