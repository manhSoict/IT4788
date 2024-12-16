import 'package:flutter/material.dart';
import 'package:it_4788/src/views/create_class_view.dart';
import 'package:it_4788/src/views/create_exercise_view.dart';
import 'package:path/path.dart';

import '../views/document_view.dart';
import 'package:it_4788/src/views/edit_class_view.dart';
import 'package:it_4788/src/views/edit_exercise_view.dart';
import 'package:it_4788/src/views/notification_view.dart';
import '../views/exercise_view.dart';
import 'package:it_4788/src/views/chat_view.dart';
import 'package:it_4788/src/views/search_chat_view.dart';
import '../views/listchat_view.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../views/setting_view.dart';
import '../views/list_class_view.dart';
import '../views/class_detail_view.dart';
import '../views/class_list_student_view.dart';
import '../views/notify_view.dart';

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
      '/edit-class': (context) => const EditClassView(),
      '/notification': (context) => const ListAbsenceView(),
      '/notify': (context) => const NotificationScreen(),
      '/create-exercise': (context) => const CreateExerciseView(),
      '/exercise': (context) => const ExerciseListView(),
      '/edit-exercise': (context) => const EditExerciseView(),
      '/listchat': (context) => const ListChat(),
      '/searchchat': (context) => const SearchChat(),
      '/chatview': (context) => const ChatView(),
      '/lecturer-document': (context) => const DocumentTabScreen(),
    };
  }
}
