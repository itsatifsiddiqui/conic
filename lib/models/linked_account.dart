import 'package:flutter/foundation.dart';

@immutable
class LinkedAccount {
  const LinkedAccount({
    required this.image,
    required this.link,
    required this.title,
    required this.description,
    required this.focused,
    required this.notify,
    required this.hidden,
    this.media,
  });

  factory LinkedAccount.fromMap(Map<String, dynamic> map) {
    return LinkedAccount(
      image: map['image'] as String,
      link: map['link'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      focused: map['focused'] as bool,
      notify: map['notify'] as bool,
      hidden: map['hidden'] as bool,
      media: List<String>.from(
        map.containsKey('media') ? (map['media'] ?? <String>[]) as List : <String>[],
      ),
    );
  }

  final String image;
  final String link;
  final String title;
  final String description;
  final bool focused;
  final bool notify;
  final bool hidden;
  final List<String>? media;

  LinkedAccount copyWith({
    String? image,
    String? link,
    String? title,
    String? description,
    bool? focused,
    bool? notify,
    bool? hidden,
    List<String>? media,
  }) {
    return LinkedAccount(
      image: image ?? this.image,
      link: link ?? this.link,
      title: title ?? this.title,
      description: description ?? this.description,
      focused: focused ?? this.focused,
      notify: notify ?? this.notify,
      hidden: hidden ?? this.hidden,
      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'link': link,
      'title': title,
      'description': description,
      'focused': focused,
      'notify': notify,
      'hidden': hidden,
      'media': media ?? [],
    };
  }

  @override
  String toString() {
    return 'LinkedAccount(image: $image, link: $link, title: $title, description: $description, focused: $focused, notify: $notify, hidden: $hidden, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinkedAccount &&
        other.image == image &&
        other.link == link &&
        other.title == title &&
        other.description == description &&
        other.focused == focused &&
        other.notify == notify &&
        other.hidden == hidden &&
        listEquals(other.media, media);
  }

  @override
  int get hashCode {
    return image.hashCode ^
        link.hashCode ^
        title.hashCode ^
        description.hashCode ^
        focused.hashCode ^
        notify.hashCode ^
        hidden.hashCode ^
        media.hashCode;
  }
}
