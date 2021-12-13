import 'dart:convert';

import 'package:flutter/foundation.dart';

class CardModel {
  List<String>? accounts;
  String? description;
  final String? docId;
  final String? link;
  String? name;
  String? photo;
  String? theme;
  CardModel({
    this.accounts,
    this.description,
    this.docId,
    this.link,
    this.name,
    this.photo,
    this.theme,
  });

  CardModel copyWith({
    List<String>? accounts,
    String? description,
    String? docId,
    String? link,
    String? name,
    String? photo,
    String? theme,
  }) {
    return CardModel(
      accounts: accounts ?? this.accounts,
      description: description ?? this.description,
      docId: docId ?? this.docId,
      link: link ?? this.link,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accounts': accounts,
      'description': description,
      'docId': docId,
      'link': link,
      'name': name,
      'photo': photo,
      'theme': theme,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      accounts: map['accounts'] != null ? List<String>.from(map['accounts']) : null,
      description: map['description'] != null ? map['description'] : null,
      docId: map['docId'] != null ? map['docId'] : null,
      link: map['link'] != null ? map['link'] : null,
      name: map['name'] != null ? map['name'] : null,
      photo: map['photo'] != null ? map['photo'] : null,
      theme: map['theme'] != null ? map['theme'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) => CardModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CardModel(accounts: $accounts, description: $description, docId: $docId, link: $link, name: $name, photo: $photo, theme: $theme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CardModel &&
        listEquals(other.accounts, accounts) &&
        other.description == description &&
        other.docId == docId &&
        other.link == link &&
        other.name == name &&
        other.photo == photo &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return accounts.hashCode ^
        description.hashCode ^
        docId.hashCode ^
        link.hashCode ^
        name.hashCode ^
        photo.hashCode ^
        theme.hashCode;
  }
}
