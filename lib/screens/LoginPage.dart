import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF090c12),
        body: Container(
          margin: const EdgeInsets.only(left: 128.0, right: 128.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF526bf2)),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(200, 40)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/UserDashboard');
                  },
                  child: const Text('Login'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: TextButton(
                      onPressed: () {}, child: const Text("Sign Up")),
                )
              ],
            ),
          ),
        ));
  }
}
