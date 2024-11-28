import 'package:flutter/material.dart';

import 'class.dart';

class User {
  final String email;
  final String id;
  final String ho;
  final String ten;
  final String name;
  final String token;
  final String role;
  final String status;
  final Image? avatar;
  final List<Class> classList;

  User({
    required this.email,
    required this.id,
    required this.ho,
    required this.ten,
    required this.name,
    required this.token,
    required this.role,
    required this.status,
    this.avatar,
    required this.classList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var classListJson = json['class_list'] as List? ?? [];
    List<Class> classList =
        classListJson.map((e) => Class.fromJson(e)).toList();

    return User(
      email: json['email'],
      id: json['id'],
      ho: json['ho'],
      ten: json['ten'],
      name: json['name'],
      token: json['token'],
      role: json['role'],
      status: json['status'],
      avatar: json['avatar'],
      classList: classList,
    );
  }
}
