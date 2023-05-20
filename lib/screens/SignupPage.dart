import 'package:flutter/material.dart';

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
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _studnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF090c12),
        body: Center(
            child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF222429),
          ),
          margin: const EdgeInsets.all(50.0),
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      "Sign up",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _collegeController,
                      decoration: const InputDecoration(
                        labelText: 'College',
                      ),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _courseController,
                      decoration: const InputDecoration(
                        labelText: 'Course',
                      ),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _studnoController,
                      decoration: const InputDecoration(
                        labelText: 'Student No',
                      ),
                      obscureText: true,
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
                        onPressed: () {
                          Navigator.pop(context); // return to login page
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        )),
        floatingActionButton: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
