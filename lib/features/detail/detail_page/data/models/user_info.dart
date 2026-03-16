import 'package:flutter/material.dart';

class UserInfo {
  final String userId;
  final String nickname;
  final String fileName;
  final String? remarkName;
  final String? signature;
  final String? gender;
  final String? location;
  final String? age;
  final String? constellation;
  final String? occupation;
  final String? education;
  final String? hobbies;
  final List<String> photos;
  final String? conversationId;
  final String? source;

  const UserInfo({
    required this.userId,
    required this.nickname,
    required this.fileName,
    this.remarkName,
    this.signature,
    this.gender,
    this.location,
    this.age,
    this.constellation,
    this.occupation,
    this.education,
    this.hobbies,
    this.photos = const [],
    this.conversationId,
    this.source,
  });

  UserInfo copyWith({
    String? userId,
    String? nickname,
    String? fileName,
    String? remarkName,
    String? signature,
    String? gender,
    String? location,
    String? age,
    String? constellation,
    String? occupation,
    String? education,
    String? hobbies,
    List<String>? photos,
    String? conversationId,
    String? source,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      fileName: fileName ?? this.fileName,
      remarkName: remarkName ?? this.remarkName,
      signature: signature ?? this.signature,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      age: age ?? this.age,
      constellation: constellation ?? this.constellation,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      hobbies: hobbies ?? this.hobbies,
      photos: photos ?? this.photos,
      conversationId: conversationId ?? this.conversationId,
      source: source ?? this.source,
    );
  }
}

class InfoItem {
  final String label;
  final String value;

  const InfoItem({
    required this.label,
    required this.value,
  });
}
