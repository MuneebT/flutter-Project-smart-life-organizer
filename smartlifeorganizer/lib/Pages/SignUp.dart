import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartlifeorganizer/Pages/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
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
        title: const Text("SignUp"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(
                fillColor: Colors.blue,
                hintText: "Enter Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                fillColor: Colors.yellow,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                final emailText = email.text;
                final passwordText = password.text;

                if (emailText.isEmpty || passwordText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Don't leave empty fields")),
                  );
                } else {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailText, password: passwordText);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signup Successful!")),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.code}")),
                    );
                  }
                }
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text("SignUp"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text("Go To Login"),
            ),
          ],
        ),
      ),
    );
  }
}
