import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../ui/components/input/signup_input.dart';
import '../ui/components/selectbox/RoleDropdown.dart';
import '../ui/widgets/login_button.dart';
import '../ui/components/input/custom_input.dart';
import '../ui/components/button/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  late TabController _tabController;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }

    final user = await _authService.login(email, password);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setString('email', user.email);
      await prefs.setString('role', user.role);
      await prefs.setString('name', user.name);
      // print(user.name);
      await prefs.setString('userId', user.id);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF5E5E), // Red background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // Logo and Title
            Column(
              children: [
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo asset path
                  height: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'HUST',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to AllHUST',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Đăng nhập'),
                Tab(text: 'Đăng ký'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login Tab
                  _buildLoginTab(),
                  // Register Tab (empty for now)
                  _buildSignUpTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          // Email Field
          CustomInput(
            controller: _emailController,
            hintText: 'Email hoặc mã số SV/CB',
            leftIcon: Icons.person,
          ),
          const SizedBox(height: 15),

          // Password Field
          CustomInput(
            controller: _passwordController,
            hintText: 'Mật khẩu',
            leftIcon: Icons.lock,
            rightIcon:
                obscurePassword ? Icons.visibility_off : Icons.visibility,
            obscureText: obscurePassword,
            onRightIconPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),
          const SizedBox(height: 32),
          // Login Button
          LoginButton(
            text: 'ĐĂNG NHẬP',
            onPressed: _handleLogin,
            backgroundColor: Colors.white,
            textColor: const Color(0xFFFF5E5E),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFFF5E5E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo

                Row(
                  children: [
                    Expanded(
                      child: SignupInput(
                        labelText: 'Họ',
                        icon: null,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: SignupInput(
                        labelText: 'Tên',
                        icon: null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                SignupInput(
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                SizedBox(height: 15),
                SignupInput(
                  labelText: 'Password',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                SizedBox(height: 15),
                RoleDropdown(),
                SizedBox(height: 30),
                // Sign Up Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  ),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                // Login Text
              ],
            ),
          ),
        ),
      ),
    );
  }
}
