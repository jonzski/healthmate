import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class MonitorSignUpPage extends StatefulWidget {
  const MonitorSignUpPage({super.key});

  @override
  _MonitorSignUpPageState createState() => _MonitorSignUpPageState();
}

class _MonitorSignUpPageState extends State<MonitorSignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _empnoController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  final signupKey = GlobalKey<FormState>();

  final String logo = 'assets/images/Logo.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF090c12),
        body: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF222429),
                  ),
                  margin: const EdgeInsets.all(30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: signupKey,
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: SvgPicture.asset(
                                        logo,
                                        width: 60,
                                        colorFilter: const ColorFilter.mode(
                                            Color(0xFF526bf2), BlendMode.srcIn),
                                      ),
                                    ),
                                    const Text(
                                      "Health",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'SF-UI-Display',
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const Text(
                                      "Mate",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'SF-UI-Display',
                                          fontSize: 30,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ])),
                          sectionText("Create Entrance Monitor Account"),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (!EmailValidator.validate(value!) ||
                                  value == null) {
                                return 'Please enter valid email ';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid password ';
                              } else if (value.length < 8) {
                                return 'Please enter at least 8 characters';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                          sectionText("Enter your monitor information"),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please your Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          TextFormField(
                            controller: _empnoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please your employee no.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Employee No',
                            ),
                          ),
                          TextFormField(
                            controller: _positionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your position';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Position',
                            ),
                          ),
                          TextFormField(
                            controller: _unitController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your home unit';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Home Unit',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF526bf2)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 50)),
                              ),
                              onPressed: () async {
                                if (signupKey.currentState!.validate()) {
                                  signupKey.currentState!.save();

                                  final authProvider =
                                      context.read<AuthProvider>();
                                  final email = _emailController.text.trim();
                                  final password =
                                      _passwordController.text.trim();
                                  final name = _nameController.text.trim();

                                  Map<String, dynamic> newMonitor = {
                                    "empNo": _empnoController.text,
                                    "position": _positionController.text,
                                    "homeUnit": _unitController.text,
                                    "underMonitoring": false,
                                    "underQuarantine": false,
                                    "diseases": null,
                                    "allergies": null
                                  };

                                  authProvider.signUp(
                                      email, password, 3, name, newMonitor);

                                  // Might add a welcome message in the near future
                                  Navigator.pop(context);
                                } // return to login page
                              },
                              child: const SizedBox(
                                width: double.infinity,
                                child: Text('Create Account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: const Text(
                                "Back",
                                style: TextStyle(
                                  fontFamily: 'SF-UI-Display',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }

  Widget sectionText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: 'SF-UI-Display',
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    );
  }
}
