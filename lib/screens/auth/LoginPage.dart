import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../user/UserView.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String logo = 'assets/images/Logo.svg';
  final loginKey = GlobalKey<FormState>();

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
        height: 400,
        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Form(
              key: loginKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        logo,
                        width: 36,
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
                  ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF526bf2)),
                        minimumSize:
                            MaterialStateProperty.all(const Size(36, 36)),
                      ),
                      onPressed: () async {
                        if (loginKey.currentState!.validate()) {
                          loginKey.currentState!.save();
                          //final UserCredential?
                          UserCredential? user;
                          try {
                            user = await context.read<AuthProvider>().signIn(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                0);
                          } on FirebaseAuthException catch (e) {
                            // Pop Over
                            final String error = "${e.message}";
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(error)));
                            print('Errorrrr: ${e.message}');
                          }

                          if (user != null && context.mounted) {
                            // Navigator.pushReplacementNamed(context, '/user');
                            Navigator.pushNamed(context, '/user',
                                arguments: const UserView(
                                  viewer: 'Student',
                                ));
                          } else if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "You cannot sign in as a student")));
                          }
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontFamily: 'SF-UI-Display',
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'SF-UI-Display',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/switch-user-type');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: const Text(
            'Log in as Personnel',
            style: TextStyle(
                fontFamily: 'SF-UI-Display',
                fontWeight: FontWeight.w700,
                fontSize: 15),
          ),
        ),
      ),
    );
  }
}
