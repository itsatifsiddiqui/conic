import 'package:flutter/foundation.dart';
import 'linked_account.dart';

@immutable
class AppUser {
  const AppUser({
    this.name,
    this.username,
    this.email,
    this.image,
    this.userId,
    this.link,
    this.androidLink,
    this.linkedAccounts,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final linkedAccounts = map.containsKey('linkedAccounts')
        ? (map['linkedAccounts'] as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    return AppUser(
      name: map['name'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      image: map['image'] as String?,
      userId: map['userId'] as String?,
      link: map['link'] as String?,
      androidLink: map['androidLink'] as String?,
      linkedAccounts: List<LinkedAccount>.from(
        linkedAccounts.map<LinkedAccount>((x) => LinkedAccount.fromMap(x)),
      ),
    );
  }

  final String? name;
  final String? username;
  final String? email;
  final String? image;
  final String? userId;
  final String? link;
  final String? androidLink;
  final List<LinkedAccount>? linkedAccounts;

  AppUser copyWith({
    String? name,
    String? username,
    String? email,
    String? image,
    String? userId,
    String? link,
    String? androidLink,
    List<LinkedAccount>? linkedAccounts,
  }) {
    return AppUser(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      link: link ?? this.link,
      androidLink: androidLink ?? this.androidLink,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'email': email,
      'image': image,
      'userId': userId,
      'link': link,
      'androidLink': androidLink,
      'linkedAccounts': (linkedAccounts ?? []).map((x) => x.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'AppUser(name: $name, username: $username, email: $email, image: $image, userId: $userId, link: $link, androidLink: $androidLink, linkedAccounts: $linkedAccounts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.image == image &&
        other.userId == userId &&
        other.link == link &&
        other.androidLink == androidLink &&
        listEquals(other.linkedAccounts, linkedAccounts);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        image.hashCode ^
        userId.hashCode ^
        link.hashCode ^
        androidLink.hashCode ^
        linkedAccounts.hashCode;
  }
}
