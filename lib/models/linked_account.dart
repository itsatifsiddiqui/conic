import 'package:flutter/foundation.dart';

@immutable
class LinkedAccount {
  const LinkedAccount({
    required this.name,
    required this.image,
    required this.taps,
    required this.title,
    required this.description,
    required this.enteredLink,
    required this.fullLink,
    required this.focused,
    required this.notify,
    required this.hidden,
  });

  factory LinkedAccount.fromMap(Map<String, dynamic> map) {
    return LinkedAccount(
      name: map['name'] as String,
      image: map['image'] as String,
      title: map['title'] as String,
      taps: (map['taps'] ?? 0) as int,
      description: map['description'] as String,
      enteredLink: map['enteredLink'] as String?,
      fullLink: map['fullLink'] as String?,
      focused: map['focused'] as bool,
      notify: map['notify'] as bool,
      hidden: map['hidden'] as bool,
    );
  }

  //Unique Identification between account and linkedAccount
  final String name;
  final String image;
  final String title;
  final String description;
  final String? enteredLink;
  final int? taps;
  final String? fullLink;
  final bool focused;
  final bool notify;
  final bool hidden;

  LinkedAccount copyWith({
    String? name,
    String? image,
    String? title,
    String? description,
    String? enteredLink,
    String? fullLink,
    bool? focused,
    bool? notify,
    int? taps,
    bool? hidden,
    List<String>? media,
  }) {
    return LinkedAccount(
      name: name ?? this.name,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      enteredLink: enteredLink ?? this.enteredLink,
      fullLink: fullLink ?? this.fullLink,
      taps: taps ?? this.taps,
      focused: focused ?? this.focused,
      notify: notify ?? this.notify,
      hidden: hidden ?? this.hidden,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'title': title,
      'taps': taps,
      'description': description,
      'enteredLink': enteredLink,
      'fullLink': fullLink,
      'focused': focused,
      'notify': notify,
      'hidden': hidden,
    };
  }

  @override
  String toString() {
    return 'LinkedAccount(name: $name, image: $image, title: $title, description: $description, enteredLink: $enteredLink, fullLink: $fullLink, focused: $focused, taps:$taps, notify: $notify, hidden: $hidden)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinkedAccount &&
        other.name == name &&
        other.image == image &&
        other.title == title &&
        other.description == description &&
        other.enteredLink == enteredLink &&
        other.fullLink == fullLink &&
        other.focused == focused &&
        other.taps == taps &&
        other.notify == notify &&
        other.hidden == hidden;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        title.hashCode ^
        description.hashCode ^
        enteredLink.hashCode ^
        fullLink.hashCode ^
        focused.hashCode ^
        taps.hashCode ^
        notify.hashCode ^
        hidden.hashCode;
  }
}
