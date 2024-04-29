import 'package:cookbook/auth/auth_service.dart';
import 'package:cookbook/auth/validate.dart';
import 'package:cookbook/components/CustomButton.dart';
import 'package:cookbook/components/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/constant/image.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  final VoidCallback showLoginPage;
  Register({required this.showLoginPage, super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();

  var isLoading = false;
  String email = '';
  String password = '';
  String name = '';

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _signup() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show CircularProgressIndicator
      });

      try {
        _key.currentState!.save();
        // Perform signup
        await _auth.createUserWithEmailAndPassword(_email.text.trim(),
            _password.text.trim(), _name.text.trim(), context);

        // No need for navigation here, it's handled elsewhere
      } catch (e) {
        // Handle signup errors
        print('Signup error: $e');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
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
        children:[ SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 120, right: 120, top: 50),
                  child: Image.asset(signupImage),
                ),
                Form(
                  key: _key,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'You will get personalised experience!',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomTextField(
                          key: ValueKey('name'),
                          hint: "Enter Name",
                          label: "Name",
                          controller: _name,
                          validate: Validate.validateName,
                          onSaved: (value) {
                            setState(() {
                              name = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
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
                            setState(() {
                              password = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          label: "SignUp",
                          onPressed: _signup,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an Account? "),
                            GestureDetector(
                              onTap: widget.showLoginPage,
                              child: Text(
                                'LogIn',
                                style: TextStyle(color: Color(0xddEE5A25)),
                              ),
                            )
                          ],
                        ),
                        // const Spacer(),
                        //rules and policy
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
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xddEE5A25)),
                ),
              ),
            ),
    ]
      ),
    );
  }

}
