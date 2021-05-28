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
    this.followedBy,
    this.followings,
    this.sentRequests,
    this.recievedRequests,
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
      followedBy: map.containsKey('followedBy')
          ? List<String>.from((map['followedBy'] as List).cast<String>())
          : <String>[],
      followings: map.containsKey('followings')
          ? List<String>.from((map['followings'] as List).cast<String>())
          : <String>[],
      sentRequests: map.containsKey('sentRequests')
          ? List<String>.from((map['sentRequests'] as List).cast<String>())
          : <String>[],
      recievedRequests: map.containsKey('recievedRequests')
          ? List<String>.from((map['recievedRequests'] as List).cast<String>())
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
  final List<String>? followedBy;
  final List<String>? followings;
  final List<String>? sentRequests;
  final List<String>? recievedRequests;

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
    List<String>? followedBy,
    List<String>? followings,
    List<String>? sentRequests,
    List<String>? recievedRequests,
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
      followedBy: followedBy ?? this.followedBy,
      followings: followings ?? this.followings,
      sentRequests: sentRequests ?? this.sentRequests,
      recievedRequests: recievedRequests ?? this.recievedRequests,
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
      'followedBy': followedBy ?? [],
      'followings': followings ?? [],
      'sentRequests': sentRequests ?? [],
      'recievedRequests': recievedRequests ?? [],
    };
  }

  @override
  String toString() {
    return 'AppUser(name: $name, username: $username, email: $email, image: $image, userId: $userId, link: $link, androidLink: $androidLink, gridMode: $gridMode, linkedAccounts: $linkedAccounts, followedBy: $followedBy, followings: $followings, sentRequests: $sentRequests recievedRequests: $recievedRequests)';
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
        listEquals(other.followedBy, followedBy) &&
        listEquals(other.followings, followings) &&
        listEquals(other.recievedRequests, recievedRequests) &&
        listEquals(other.sentRequests, sentRequests);
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
        followedBy.hashCode ^
        followings.hashCode ^
        recievedRequests.hashCode ^
        sentRequests.hashCode;
  }
}
