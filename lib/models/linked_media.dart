import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class LinkedMedia {
  const LinkedMedia({
    required this.url,
    required this.type,
    this.timestamp,
  });

  factory LinkedMedia.fromMap(Map<String, dynamic> map) {
    return LinkedMedia(
      url: map['url'] as String,
      type: map['type'] as String,
      timestamp: map.containsKey('timestamp')
          ? map['timestamp'] as int
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  final String url;
  final String type;
  final int? timestamp;
  LinkedMedia copyWith({
    String? url,
    String? type,
    int? timestamp,
  }) {
    return LinkedMedia(
      url: url ?? this.url,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  String toString() => 'LinkedMedia(url: $url, type: $type, timestamp: $timestamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinkedMedia &&
        other.url == url &&
        other.type == type &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode ^ timestamp.hashCode;

  String toJson() => json.encode(toMap());

  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';
  bool get isPdf => type == 'pdf';
}
