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
    this.gridMode,
    this.linkedAccounts,
    this.followRequestsRecieved,
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
      gridMode: map['gridMode'] as bool?,
      linkedAccounts: List<LinkedAccount>.from(
        linkedAccounts.map<LinkedAccount>((x) => LinkedAccount.fromMap(x)),
      ),
      followRequestsRecieved: map.containsKey('followRequestsRecieved')
          ? List<String>.from((map['followRequestsRecieved'] as List).cast<String>())
          : <String>[],
    );
  }

  final String? name;
  final String? username;
  final String? email;
  final String? image;
  final String? userId;
  final String? link;
  final String? androidLink;
  final bool? gridMode;
  final List<LinkedAccount>? linkedAccounts;
  final List<String>? followRequestsRecieved;

  AppUser copyWith({
    String? name,
    String? username,
    String? email,
    String? image,
    String? userId,
    String? link,
    String? androidLink,
    bool? gridMode,
    List<LinkedAccount>? linkedAccounts,
    List<String>? followRequestsRecieved,
  }) {
    return AppUser(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      link: link ?? this.link,
      androidLink: androidLink ?? this.androidLink,
      gridMode: gridMode ?? this.gridMode,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      followRequestsRecieved: followRequestsRecieved ?? this.followRequestsRecieved,
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
      'gridMode': gridMode,
      'linkedAccounts': (linkedAccounts ?? []).map((x) => x.toMap()).toList(),
      'followRequestsRecieved': followRequestsRecieved,
    };
  }

  @override
  String toString() {
    return 'AppUser(name: $name, username: $username, email: $email, image: $image, userId: $userId, link: $link, androidLink: $androidLink, gridMode: $gridMode, linkedAccounts: $linkedAccounts, followRequestsRecieved: $followRequestsRecieved)';
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
        other.gridMode == gridMode &&
        listEquals(other.linkedAccounts, linkedAccounts) &&
        listEquals(other.followRequestsRecieved, followRequestsRecieved);
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
        gridMode.hashCode ^
        linkedAccounts.hashCode ^
        followRequestsRecieved.hashCode;
  }
}
