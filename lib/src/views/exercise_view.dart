import 'package:flutter/material.dart';
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

  // Fetch exercises when the page is loaded
  @override
  void initState() {
    super.initState();
    _loadUserData();  // Load the token first
  }

  // Load the user data (token) from shared preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token');  // Retrieve the token
    });

    // If token is null, show an error message, otherwise fetch exercises
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
    if (token == null) return;  // Ensure token is not null

    var response = await _exerciseService.getAllExercises(
      token: token!,
      classId: '000087',
    );

    setState(() {
      _isLoading = false;
      if (response['success']) {
        _exercises = response['data'];  // Assuming data contains the list of exercises
      } else {
        _errorMessage = response['message'];
      }
    });
  }

  // Navigate to /create-exercise page when the + button is clicked
  void _navigateToCreateExercise() {
    Navigator.pushNamed(context, '/create-exercise');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise List'),
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
              // Handle tap (e.g., navigate to a detailed page)
              print('Tapped on ${exercise['title']}');
            },
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
