import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _studnoController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  final signupKey = GlobalKey<FormState>();

  final String logo = 'assets/images/Logo.svg';

  static final List<String> _colleges = [
    "CAFS",
    "CAS",
    "CDC",
    "CEM",
    "CEAT",
    "CFNR",
    "CHE",
    "CVM",
    "Graduate School",
  ];

  static final Map<String, bool> _preIllness = {
    "Hypertension": false,
    "Diabetes": false,
    "Tuberculosis": false,
    "Cancer": false,
    "Kidney Disease": false,
    "Cardiac Disease": false,
    "Autoimmune Disease": false,
    "Asthma": false,
  };

  String _collegeValue = _colleges.first;
  List<String>? allergies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090c12),
      body: Center(
        child: Container(
            height: 1000,
            width: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF222429),
            ),
            margin: const EdgeInsets.all(50.0),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: signupKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                        "OHMS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'SF-UI-Display',
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      const Text(
                        "Mobile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'SF-UI-Display',
                            fontSize: 30,
                            fontWeight: FontWeight.w300),
                      ),
                    ]),
                    sectionText("Create your login"),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (!EmailValidator.validate(value!) || value == null) {
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
                    sectionText("Enter your user information"),
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
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please your username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _collegeValue,
                      onChanged: (String? value) {
                        setState(() {
                          _collegeValue = value!;
                        });
                      },
                      items: _colleges.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    TextFormField(
                      controller: _courseController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please your course';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Course',
                      ),
                    ),
                    TextFormField(
                      controller: _studnoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please your student number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Student No',
                      ),
                    ),
                    sectionText("Check if you have pre-existing illness"),
                    Column(
                      children: _preIllness.keys
                          .map((String key) => CheckboxListTile(
                                title: Text(key),
                                value: _preIllness[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _preIllness[key] = value!;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    sectionText("Any allergies"),
                    TextFormField(
                      controller: _allergiesController,
                      decoration: const InputDecoration(
                        labelText: '(Optional)',
                      ),
                    ),
                    const Text(
                      "Separate each entries using comma",
                      style: TextStyle(
                          fontFamily: 'SF-UI-Display',
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(178, 243, 243, 243)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF526bf2)),
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50)),
                        ),
                        onPressed: () async {
                          if (signupKey.currentState!.validate()) {
                            signupKey.currentState!.save();

                            final authProvider = context.read<AuthProvider>();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final name = _nameController.text.trim();
                            final allergiesEntry =
                                _allergiesController.text.split(',');

                            Map<String, dynamic> newUser = {
                              "username": _usernameController.text.trim(),
                              "college": _collegeValue,
                              "course": _courseController.text,
                              "studentNum": _studnoController.text,
                              "underMonitoring": false,
                              "underQuarantine": false,
                              "diseases": _preIllness,
                              "allergies": allergiesEntry
                            };

                            authProvider.signUp(
                                email, password, 0, name, newUser);
                            Navigator.pop(context);
                          } // return to login page
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
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
      // floatingActionButton: Align(
      //   alignment: Alignment.topLeft,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 20.0, left: 10.0),
      //     child: TextButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       style: ButtonStyle(
      //         backgroundColor: MaterialStateProperty.all(Colors.transparent),
      //         overlayColor: MaterialStateProperty.all(Colors.transparent),
      //       ),
      //       child: const Icon(
      //         Icons.arrow_back_outlined,
      //         size: 30.0,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // )
    );
  }

  Widget sectionText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
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
