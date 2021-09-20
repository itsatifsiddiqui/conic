import 'package:flutter/foundation.dart';

import 'linked_account.dart';
import 'linked_media.dart';

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
    this.businessMode,
    this.focusedMode,
    this.linkedAccounts,
    this.linkedMedias,
    this.followRequestsRecieved,
    this.followedBy,
    this.isFollowing,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final linkedAccounts = map.containsKey('linkedAccounts')
        ? (map['linkedAccounts'] as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    final linkedMedias = map.containsKey('linkedMedias')
        ? (map['linkedMedias'] as List).cast<Map<String, dynamic>>()
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
      businessMode: (map['businessMode'] ?? false) as bool?,
      focusedMode: (map['focusedMode'] ?? false) as bool?,
      linkedAccounts: List<LinkedAccount>.from(
        linkedAccounts.map<LinkedAccount>((x) => LinkedAccount.fromMap(x)),
      ),
      linkedMedias: List<LinkedMedia>.from(
        linkedMedias.map<LinkedMedia>((x) => LinkedMedia.fromMap(x)),
      ),
      followRequestsRecieved: map.containsKey('followRequestsRecieved')
          ? List<String>.from((map['followRequestsRecieved'] as List).cast<String>())
          : <String>[],
      followedBy: map.containsKey('followedBy')
          ? List<String>.from((map['followedBy'] as List).cast<String>())
          : <String>[],
      isFollowing: map.containsKey('isFollowing')
          ? List<String>.from((map['isFollowing'] as List).cast<String>())
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
  final bool? businessMode;
  final bool? focusedMode;
  final List<LinkedAccount>? linkedAccounts;
  final List<LinkedMedia>? linkedMedias;
  final List<String>? followRequestsRecieved;
  final List<String>? followedBy;
  final List<String>? isFollowing;

  AppUser copyWith({
    String? name,
    String? username,
    String? email,
    String? image,
    String? userId,
    String? link,
    String? androidLink,
    bool? gridMode,
    bool? businessMode,
    bool? focusedMode,
    List<LinkedAccount>? linkedAccounts,
    List<LinkedMedia>? linkedMedias,
    List<String>? followRequestsRecieved,
    List<String>? followedBy,
    List<String>? isFollowing,
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
      focusedMode: focusedMode ?? this.focusedMode,
      businessMode: businessMode ?? this.businessMode,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      linkedMedias: linkedMedias ?? this.linkedMedias,
      followRequestsRecieved: followRequestsRecieved ?? this.followRequestsRecieved,
      followedBy: followedBy ?? this.followedBy,
      isFollowing: isFollowing ?? this.isFollowing,
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
      'focusedMode': focusedMode,
      'businessMode': businessMode,
      'linkedAccounts': (linkedAccounts ?? []).map((x) => x.toMap()).toList(),
      'linkedMedias': (linkedMedias ?? []).map((x) => x.toMap()).toList(),
      'followRequestsRecieved': followRequestsRecieved ?? [],
      'followedBy': followedBy ?? [],
      'isFollowing': isFollowing ?? [],
    };
  }

  @override
  String toString() {
    return 'AppUser(name: $name, username: $username, email: $email, image: $image, userId: $userId, link: $link, androidLink: $androidLink, gridMode: $gridMode, focusedMode: $focusedMode, businessMode: $businessMode, linkedAccounts: $linkedAccounts, linkedMedias: $linkedMedias followRequestsRecieved: $followRequestsRecieved, followedBy: $followedBy, isFollowing: $isFollowing)';
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
        other.businessMode == businessMode &&
        other.focusedMode == focusedMode &&
        listEquals(other.linkedAccounts, linkedAccounts) &&
        listEquals(other.linkedMedias, linkedMedias) &&
        listEquals(other.followRequestsRecieved, followRequestsRecieved) &&
        listEquals(other.followedBy, followedBy) &&
        listEquals(other.isFollowing, isFollowing);
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
        businessMode.hashCode ^
        focusedMode.hashCode ^
        linkedAccounts.hashCode ^
        linkedMedias.hashCode ^
        followRequestsRecieved.hashCode ^
        followedBy.hashCode ^
        isFollowing.hashCode;
  }
}
