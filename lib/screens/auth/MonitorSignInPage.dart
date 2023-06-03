import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class MonitorSignInPage extends StatefulWidget {
  const MonitorSignInPage({super.key});

  @override
  _MonitorSignInPageState createState() => _MonitorSignInPageState();
}

class _MonitorSignInPageState extends State<MonitorSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String logo = 'assets/images/Logo.svg';
  final loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090c12),
      body: ListView(
        padding: const EdgeInsets.only(top: 200),
        children: [
          Center(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF222429),
            ),
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 50, left: 30, right: 30, bottom: 15),
                child: Center(
                    child: Form(
                  key: loginKey,
                  child: Column(
                    children: [
                      Row(
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
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
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF526bf2)),
                            minimumSize:
                                MaterialStateProperty.all(const Size(100, 50)),
                          ),
                          onPressed: () async {
                            if (loginKey.currentState!.validate()) {
                              loginKey.currentState!.save();

                              try {
                                final UserCredential user = await context
                                    .read<AuthProvider>()
                                    .signIn(_emailController.text.trim(),
                                        _passwordController.text.trim());

                                if (user != null && context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, '/monitor');
                                }
                              } catch (e) {
                                print('Error: $e');
                              }
                            }
                          },
                          child: const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Login as Entrance Monitor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'SF-UI-Display',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/monitor-signup');
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
          ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: const Text(
          'Log in as Student',
          style: TextStyle(
              fontFamily: 'SF-UI-Display',
              fontWeight: FontWeight.w700,
              fontSize: 15),
        ),
      ),
    );
  }
}
