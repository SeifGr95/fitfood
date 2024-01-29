import 'package:fitfood/AuthService.dart';
import 'package:fitfood/screens/authentification/login.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(192, 29, 224, 126))),
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isNotEmpty && password.isNotEmpty) {
                final user =
                    await _authService.signUpWithEmailPassword(email, password);

                if (user != null) {
                  // Successfully signed up
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade100,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Color.fromARGB(255, 5, 202, 31), size: 30),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text("Succ",
                                style: const TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                  ));
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => Login()));
                  print("User signed up: ${user.email}");
                } else {
                  // Sign-up failed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade100,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 30),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text("Sign-up failed",
                                style: const TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                  ));
                  print("Sign-up with email and password failed");
                }
              } else {
                // Handle empty fields
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade100,
                  content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.red, size: 30),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text("Please enter email and password",
                              style: const TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ));
                print("Please enter email and password");
              }
            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
