import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/header2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/exercise_service.dart';
import '../ui/components/card/ExerciseCard.dart';

class ExerciseListView extends StatefulWidget {
  const ExerciseListView({Key? key}) : super(key: key);

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListView> {
  final ExerciseService _exerciseService = ExerciseService();
  bool _isLoading = true;
  List<dynamic> _exercises = [];
  String _errorMessage = '';
  String? token;
  String? classId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load the user data (token) from shared preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token');
      classId = prefs.getString('classId');
    });

    if (token != null) {
      _fetchExercises();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Token not found. Please log in again.';
      });
    }
  }

  // Function to fetch exercises
  Future<void> _fetchExercises() async {
    if (token == null) return;

    var response = await _exerciseService.getAllExercises(
      token: token!,
      classId: classId!,
    );

    setState(() {
      _isLoading = false;
      if (response['success']) {
        _exercises = response['data'];
      } else {
        _errorMessage = response['message'];
      }
    });
  }

  void _navigateToCreateExercise() {
    Navigator.pushNamed(context, '/create-exercise');
  }

  // Function to handle Edit action
  void _editExercise() {
    Navigator.pushNamed(context, '/edit-exercise');
  }

  // Function to handle Delete action
  Future<void> _deleteExercise(int surveyId) async {
    var response = await _exerciseService.deleteExercise(
      token: token!,
      surveyId: surveyId,
    );

    if (response['success']) {
      setState(() {
        _exercises.removeWhere((exercise) => exercise['id'] == surveyId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exercise deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete exercise')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header2(title: 'Danh sách bài tập'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text('Error: $_errorMessage'))
          : ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          var exercise = _exercises[index];
          return ExerciseTile(
            title: exercise['title'],
            description: exercise['description'],
            onTap: () {

            },
            onEdit: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('exerciseId', exercise['id']);
              _editExercise();
            },
            onDelete: () => _deleteExercise(exercise['id']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateExercise,
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFFFF5E5E),
        tooltip: 'Create Exercise',
      ),
    );
  }
}
