import 'package:cookbook/auth/validate.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/auth/auth_service.dart';
import 'package:cookbook/components/CustomButton.dart';
import 'package:cookbook/components/CustomTextField.dart';
import 'package:cookbook/components/Square_tile.dart';
import 'package:flutter/widgets.dart';
import 'package:cookbook/constant/image.dart';

class LogIn extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const LogIn({required this.showSignUpPage, super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _auth = AuthService();

  var isLoading = false;
  String email = '';
  String password = '';

  final _email = TextEditingController();
  final _password = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _login() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show CircularProgressIndicator
      });

      try {
        _key.currentState!.save();
        //perform login
        await _auth.loginUserWithEmailAndPassword(
            _email.text.trim(), _password.text.trim(), context);
      } catch (e) {
        //handle login errors
        print('Login error: $e');
        //optionally, show an error to user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed. Please try again.'),
          duration: Duration(seconds: 3),
        ));
      } finally {
        setState(() {
          isLoading = false; // Hide CircularProgressIndicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 120, right: 120, top: 50),
                    child: Image.asset(loginImage),
                  ),
                  Form(
                    key: _key,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'Welcome back, Chef! You\'ve been missed.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CustomTextField(
                            key: ValueKey('email'),
                            hint: "Enter Email",
                            label: "Email",
                            controller: _email,
                            validate: Validate.validateEmail,
                            onSaved: (value) {
                              setState(() {
                                email = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            key: ValueKey('password'),
                            hint: "Enter Password",
                            label: "Password",
                            isPassword: true,
                            controller: _password,
                            validate: Validate.validatePassword,
                            onSaved: (value) {
                              password = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            label: "LogIn",
                            onPressed: _login,
                          ),
                          const SizedBox(
                              height: 30
                          ),
                          SquareTile(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await _auth.loginWithGoogle();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            imagePath: 'images/google.png',
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don\'t have an Account? "),
                              GestureDetector(
                                onTap: widget.showSignUpPage,
                                child: Text(
                                  'SignUp',
                                  style: TextStyle(color: Color(0xddEE5A25)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.grey[600]!.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xddEE5A25)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}