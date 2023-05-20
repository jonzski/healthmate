import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String logo = 'assets/images/Logo.svg';

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
        height: 450,
        width: 400,
        margin: const EdgeInsets.only(left: 80.0, right: 80.0),
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Column(children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
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
                            MaterialStateProperty.all(const Size(100, 50)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/UserDashboard');
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Signup');
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
            )),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 20,
        margin: const EdgeInsets.all(100),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/SwitchUserType');
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
