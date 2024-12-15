import 'package:flutter/material.dart';
import 'package:it_4788/src/views/chat_view.dart';
import 'package:it_4788/src/views/search_chat_view.dart';
import '../views/listchat_view.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../views/setting_view.dart';
import '../views/list_class_view.dart';
import '../views/class_detail_view.dart';
// ignore: duplicate_import
import '../views/search_chat_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const LoginView(),
      '/home': (context) => const HomeView(),
      '/setting': (context) => const SettingView(),
      '/listclass': (context) => const ListClassView(),
      '/classdetail': (context) => const ClassDetailView(),
      '/listchat': (context) => const ListChat(),
      '/searchchat': (context) => const SearchChat(),
      '/chatview': (context) => const ChatView(
            partnerId: "485",
            conversationId: "5927",
          ),
    };
  }
}
