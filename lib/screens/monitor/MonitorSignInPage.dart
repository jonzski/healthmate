import 'package:flutter/material.dart';

class MonitorSignInPage extends StatefulWidget {
  const MonitorSignInPage({super.key});

  @override
  _MonitorSignInPageState createState() => _MonitorSignInPageState();
}

class _MonitorSignInPageState extends State<MonitorSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          Text(
                            " Monitor Login ",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),
                          ),
                        ]),
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
                      obscureText: true,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF526bf2)),
                        minimumSize:
                            MaterialStateProperty.all(const Size(100, 50)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/MonitorDashboard');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/MonitorSignUp');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: const Text("Sign Up"),
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
