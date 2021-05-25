import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class AccountModel {
  const AccountModel({
    required this.name,
    required this.image,
    required this.field,
    required this.fieldHint,
    required this.title,
    required this.description,
    required this.prefix,
    this.suffix,
    required this.regex,
    required this.position,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      name: map['name'] as String,
      image: map['image'] as String,
      field: map['field'] as String,
      fieldHint: map['fieldHint'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      prefix: map['prefix'] as String?,
      suffix: map['suffix'] as String?,
      regex: map['regex'] as String?,
      position: map['position'] as int,
    );
  }

  //Uniquely Identifies an account
  final String name;
  final String image;
  final String field;
  final String fieldHint;
  final String title;
  final String description;
  final String? prefix;
  final String? suffix;
  final String? regex;
  final int position;

  AccountModel copyWith({
    String? name,
    String? image,
    String? field,
    String? fieldHint,
    String? title,
    String? description,
    String? prefix,
    String? suffix,
    String? regex,
    int? position,
  }) {
    return AccountModel(
      name: name ?? this.name,
      image: image ?? this.image,
      field: field ?? this.field,
      fieldHint: fieldHint ?? this.fieldHint,
      title: title ?? this.title,
      description: description ?? this.description,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      regex: regex ?? this.regex,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'field': field,
      'fieldHint': fieldHint,
      'title': title,
      'description': description,
      'prefix': prefix,
      'suffix': suffix,
      'regex': regex,
      'position': position,
    };
  }

  @override
  String toString() {
    return 'AccountModel(name: $name, image: $image, field: $field, fieldHint: $fieldHint, title: $title, description: $description, prefix: $prefix, suffix: $suffix, regex: $regex, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountModel &&
        other.name == name &&
        other.image == image &&
        other.field == field &&
        other.fieldHint == fieldHint &&
        other.title == title &&
        other.description == description &&
        other.prefix == prefix &&
        other.suffix == suffix &&
        other.regex == regex &&
        other.position == position;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        field.hashCode ^
        fieldHint.hashCode ^
        title.hashCode ^
        description.hashCode ^
        prefix.hashCode ^
        suffix.hashCode ^
        regex.hashCode ^
        position.hashCode;
  }

  bool isValidLink(String value) {
    final regexString = this.regex;
    if (regexString == null || regexString.isEmpty) return true;

    final regex = RegExp(regexString);
    if (regex.hasMatch(value)) {
      return true;
    }
    final merged = prefix! + value;

    if (regex.hasMatch(merged)) return true;

    return false;
  }

  String getLink(String value) {
    final regexString = this.regex;
    if (regexString == null || regexString.isEmpty) return value;
    final isLink = value.contains('.com') || (value.contains('http') && value.contains('://'));
    if (isValidLink(value) && isLink) {
      return value;
    }

    final regex = RegExp(regexString);
    debugPrint(regex.hasMatch(value).toString());
    if (regex.hasMatch(value)) {
      var merged = value;
      if (prefix != null && prefix!.isNotEmpty) {
        merged = prefix! + merged;
      }
      if (suffix != null && suffix!.isNotEmpty) {
        merged = merged + suffix!;
      }
      return merged;
    }

    return (prefix ?? '') + value + (suffix ?? '');
  }
}

final globalAccounts = <AccountModel>[
  const AccountModel(
      name: 'Phone Number',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Fcall.png?alt=media&token=e6b4f832-eb12-4172-89b3-c89f79f25d72',
      field: 'Phone Number',
      fieldHint: '0333333333',
      title: 'My Phone Number',
      description: 'This is my personal phone number',
      position: 1,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'WhatsApp',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Fwhatsapp.png?alt=media&token=2d76f477-67a2-44d9-b0a8-7410f35990fc',
      title: 'My WhatsApp',
      field: 'WhatsApp Phone Number',
      fieldHint: '0333333333',
      description: 'This is my business whatsapp number',
      position: 2,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Email',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Fmail.png?alt=media&token=bc64ad46-97d2-413a-9ddf-1e670b6a44f0',
      field: 'Email Address',
      fieldHint: 'your-email@email.com, ',
      title: 'My Email',
      description: 'This is my personal email address',
      position: 3,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Facebook',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Ffacebook.png?alt=media&token=3ce80c15-331a-42a1-927c-fe4d4b19c1bf',
      title: 'My Facebook',
      field: 'Facebook URL',
      fieldHint: 'facebook.com/',
      description: 'This is my personal account',
      position: 4,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Instagram',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Finstagram.png?alt=media&token=83895e5a-4444-4055-bffe-cead63af409c',
      title: 'My Instagram',
      field: 'Instagram Username or URL',
      fieldHint: 'itsatifsiddiqui or instagram.com/your-username',
      description: 'This is my personal account',
      position: 5,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'LinkedIn',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Flinkedin.png?alt=media&token=cf62bd1c-c036-43a4-b928-15fc2c0ed2a7',
      title: 'My LinkedIn',
      field: 'LinkedIn Username or URL',
      fieldHint: 'itsatifsiddiqui or linkedin.com/your-username',
      description: 'This is my personal account',
      position: 6,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Snapchat',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Fsnapchat.png?alt=media&token=9450759f-ee6e-4064-bc92-764eea54ad7d',
      title: 'My Snapchat',
      field: 'Snapchat Username or URL',
      fieldHint: 'itsatifsiddiqui or snapchat.com/your-username',
      description: 'This is my personal account',
      position: 7,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Tik Tok',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Ftiktok.png?alt=media&token=8d7c2e3d-c1eb-4e3c-9b1e-c5bcc50feb6e',
      title: 'My Tik Tok',
      field: 'Tik Tok Username or URL',
      fieldHint: 'itsatifsiddiqui or ticktok.com/@your-username',
      description: 'This is my personal account',
      position: 8,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Twitter',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Ftwitter.png?alt=media&token=86a9fffa-12a1-4b50-b466-b9519775a0c1',
      title: 'My Twitter',
      field: 'Twitter Username or URL',
      fieldHint: 'itsatifsiddiqui or twitter.com/your-username',
      description: 'This is my personal account',
      position: 9,
      prefix: '',
      regex: ''),
  const AccountModel(
      name: 'Youtube',
      image:
          'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Fyoutube.png?alt=media&token=93ba0d76-437c-4a49-ba84-ee1206558407',
      title: 'My Youtube Channel',
      field: 'Youtube URL',
      fieldHint: 'youtube.com/',
      description: 'This is my personal youtube channel',
      position: 10,
      prefix: '',
      regex: ''),
  const AccountModel(
    name: 'Website',
    image:
        'https://firebasestorage.googleapis.com/v0/b/conic-688fe.appspot.com/o/accounts%2Flink.png?alt=media&token=1a3a8b98-9c7b-44b6-b336-3174162b5771',
    title: 'My Personal Website',
    field: 'Website URL',
    fieldHint: 'itsatifsiddiqui.com',
    description: 'This is my personal Website',
    position: 11,
    prefix: '',
    regex: '',
  ),
];

void globalAccountsUploader() {
  final allAccountsMap = globalAccounts.map((e) => e.toMap()).toList();
  FirebaseFirestore.instance
      .collection('accounts')
      .doc('all_accounts')
      .set(<String, dynamic>{'all_accounts': allAccountsMap});
}
