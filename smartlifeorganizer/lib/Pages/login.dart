import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartlifeorganizer/Pages/HomePage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(
                hintText: "Enter Email",
                filled: true,
                fillColor: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16), // Spacing between fields
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                filled: true,
                fillColor: Colors.yellowAccent,
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
                onPressed: () async {
                  final emailText = email.text.trim();
                  final passwordText = password.text;

                  if (emailText.isEmpty || passwordText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Don't leave fields empty")),
                    );
                    return;
                  }

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailText,
                      password: passwordText,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Successful")),
                    );

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Homepage()));
                  } on FirebaseAuthException catch (e) {
                    String message = "Login failed";
                    if (e.code == "invalid-email") {
                      message = "Invalid email format";
                    } else if (e.code == "wrong-password") {
                      message = "Wrong password";
                    } else if (e.code == "user-not-found") {
                      message = "User not found";
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  }
                },
                child: const Text("Loign"))
          ],
        ),
      ),
    );
  }
}
