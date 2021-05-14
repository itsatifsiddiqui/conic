import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  const AppUser({
    this.name,
    this.username,
    this.email,
    this.image,
    this.userId,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      image: map['image'] as String?,
      userId: map['userId'] as String?,
    );
  }

  final String? name;
  final String? username;
  final String? email;
  final String? image;
  final String? userId;

  AppUser copyWith({
    String? name,
    String? username,
    String? email,
    String? image,
    String? userId,
  }) {
    return AppUser(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'email': email,
      'image': image,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'AppUser(name: $name, username: $username, email: $email, image: $image, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.image == image &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        image.hashCode ^
        userId.hashCode;
  }
}
