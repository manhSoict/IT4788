import 'package:flutter/material.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../views/setting_view.dart';
import '../views/list_class_view.dart';
import '../views/class_detail_view.dart';
import '../views/class_list_student_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const LoginView(),
      '/home': (context) => const HomeView(),
      '/setting': (context) => const SettingView(),
      '/listclass': (context) => const ListClassView(),
      '/classdetail': (context) => const ClassDetailView(),
      '/class-list-student': (context) => const ClassListStudentView(),
      '/class_details': (context) => const ClassDetailPage()
    };
  }
}
