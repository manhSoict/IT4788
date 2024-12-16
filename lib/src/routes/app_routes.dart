import 'package:flutter/material.dart';
import 'package:it_4788/src/views/create_class_view.dart';
import 'package:it_4788/src/views/create_exercise_view.dart';
import 'package:it_4788/src/views/notification_view.dart';
import '../views/exercise_view.dart';
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
      '/create-class': (context) => const CreateClassView(),
      '/notification': (context) => const NotificationScreen(),
      '/create-exercise': (context) => const CreateExerciseView(),
      '/exercise': (context) => const ExerciseListView()
    };
  }
}
