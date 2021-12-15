import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'linked_account.dart';
import 'linked_media.dart';

class CustomLatLon {
  final double lat;
  final double lon;
  CustomLatLon({
    required this.lat,
    required this.lon,
  });

  CustomLatLon copyWith({
    double? lat,
    double? lon,
  }) {
    return CustomLatLon(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }

  factory CustomLatLon.fromMap(Map<String, dynamic> map) {
    return CustomLatLon(
      lat: map['lat']?.toDouble() ?? 0.0,
      lon: map['lon']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomLatLon.fromJson(String source) => CustomLatLon.fromMap(json.decode(source));

  @override
  String toString() => 'CustomLatLon(lat: $lat, lon: $lon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomLatLon && other.lat == lat && other.lon == lon;
  }

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}

class AppUser {
  AppUser({
    this.name,
    this.username,
    this.email,
    this.image,
    this.userId,
    this.nfcTaps,
    this.link,
    this.androidLink,
    this.gridMode,
    this.hiddenMode,
    this.customLatLons,
    this.dayStreak,
    this.focusedMode,
    this.lastTapDate,
    this.linkedAccounts,
    this.linkedMedias,
    this.followRequestsRecieved,
    this.followedBy,
    this.isFollowing,
    this.tokens,
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
      dayStreak: (map['dayStreak'] ?? 0) as int,
      email: map['email'] as String?,
      image: map['image'] as String?,
      userId: map['userId'] as String?,
      lastTapDate: (map['lastTapDate'] ?? 0) as int,
      nfcTaps: (map['nfcTaps'] ?? 0) as int,
      customLatLons: map.containsKey('customLatLons')
          ? List<CustomLatLon>.from(
              map['customLatLons'].map<CustomLatLon>((x) => CustomLatLon.fromMap(x)),
            )
          : <CustomLatLon>[],
      link: map['link'] as String?,
      androidLink: map['androidLink'] as String?,
      gridMode: map['gridMode'] as bool?,
      hiddenMode: (map['hiddenMode'] ?? false) as bool?,
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
      followedBy:
          map.containsKey('followedBy') ? List<String>.from((map['followedBy'] as List).cast<String>()) : <String>[],
      isFollowing:
          map.containsKey('isFollowing') ? List<String>.from((map['isFollowing'] as List).cast<String>()) : <String>[],
      tokens: map.containsKey('tokens') ? List<String>.from((map['tokens'] as List).cast<String>()) : <String>[],
    );
  }

  final String? name;
  final String? username;
  final String? email;
  final String? image;
  final String? userId;
  final String? link;
  final int? nfcTaps;
  final String? androidLink;
  final int? lastTapDate;
  final bool? gridMode;
  final bool? hiddenMode;
  final bool? focusedMode;
  final int? dayStreak;
  List<LinkedAccount>? linkedAccounts;
  final List<LinkedMedia>? linkedMedias;
  final List<String>? followRequestsRecieved;
  final List<String>? followedBy;
  final List<String>? isFollowing;
  final List<String>? tokens;
  final List<CustomLatLon>? customLatLons;
  AppUser copyWith({
    String? name,
    String? username,
    String? email,
    String? image,
    int? lastTapDate,
    int? dayStreak,
    String? userId,
    int? nfcTaps,
    List<CustomLatLon>? customLatLons,
    String? link,
    String? androidLink,
    bool? gridMode,
    bool? hiddenMode,
    bool? focusedMode,
    List<LinkedAccount>? linkedAccounts,
    List<LinkedMedia>? linkedMedias,
    List<String>? followRequestsRecieved,
    List<String>? followedBy,
    List<String>? isFollowing,
    List<String>? tokens,
  }) {
    return AppUser(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      link: link ?? this.link,
      nfcTaps: nfcTaps ?? this.nfcTaps,
      lastTapDate: lastTapDate ?? this.lastTapDate,
      androidLink: androidLink ?? this.androidLink,
      gridMode: gridMode ?? this.gridMode,
      dayStreak: dayStreak ?? this.dayStreak,
      focusedMode: focusedMode ?? this.focusedMode,
      customLatLons: customLatLons ?? this.customLatLons,
      hiddenMode: hiddenMode ?? this.hiddenMode,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      linkedMedias: linkedMedias ?? this.linkedMedias,
      followRequestsRecieved: followRequestsRecieved ?? this.followRequestsRecieved,
      followedBy: followedBy ?? this.followedBy,
      isFollowing: isFollowing ?? this.isFollowing,
      tokens: tokens ?? this.tokens,
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
      'lastTapDate': lastTapDate ?? 0,
      'nfcTaps': nfcTaps ?? 0,
      'dayStreak': dayStreak ?? 0,
      'gridMode': gridMode,
      'focusedMode': focusedMode,
      'hiddenMode': hiddenMode ?? false,
      'customLatLons': (customLatLons ?? []).map((x) => x.toMap()).toList(),
      'linkedAccounts': (linkedAccounts ?? []).map((x) => x.toMap()).toList(),
      'linkedMedias': (linkedMedias ?? []).map((x) => x.toMap()).toList(),
      'followRequestsRecieved': followRequestsRecieved ?? [],
      'followedBy': followedBy ?? [],
      'isFollowing': isFollowing ?? [],
      'tokens': tokens ?? [],
    };
  }

  @override
  String toString() {
    return 'AppUser(name: $name, lastTapDate:$lastTapDate, dayStreak: $dayStreak, username: $username, customLatLons:$customLatLons nfcTaps: $nfcTaps, email: $email, image: $image, userId: $userId, link: $link, androidLink: $androidLink, gridMode: $gridMode, focusedMode: $focusedMode, businessMode: $hiddenMode, linkedAccounts: $linkedAccounts, linkedMedias: $linkedMedias followRequestsRecieved: $followRequestsRecieved, followedBy: $followedBy, isFollowing: $isFollowing, tokens: $tokens)';
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
        other.dayStreak == dayStreak &&
        other.lastTapDate == lastTapDate &&
        other.link == link &&
        other.androidLink == androidLink &&
        other.gridMode == gridMode &&
        other.hiddenMode == hiddenMode &&
        other.focusedMode == focusedMode &&
        other.nfcTaps == nfcTaps &&
        listEquals(other.customLatLons, customLatLons) &&
        listEquals(other.linkedAccounts, linkedAccounts) &&
        listEquals(other.linkedMedias, linkedMedias) &&
        listEquals(other.followRequestsRecieved, followRequestsRecieved) &&
        listEquals(other.followedBy, followedBy) &&
        listEquals(other.tokens, tokens) &&
        listEquals(other.isFollowing, isFollowing);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        image.hashCode ^
        userId.hashCode ^
        dayStreak.hashCode ^
        link.hashCode ^
        androidLink.hashCode ^
        gridMode.hashCode ^
        hiddenMode.hashCode ^
        focusedMode.hashCode ^
        nfcTaps.hashCode ^
        customLatLons.hashCode ^
        linkedAccounts.hashCode ^
        linkedMedias.hashCode ^
        followRequestsRecieved.hashCode ^
        followedBy.hashCode ^
        lastTapDate.hashCode ^
        tokens.hashCode ^
        isFollowing.hashCode;
  }
}
