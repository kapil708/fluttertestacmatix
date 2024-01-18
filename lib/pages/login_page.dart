import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../services/session_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "We don't found any account please login to continue.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 32),
            isLoading
                ? const CircularProgressIndicator()
                : FilledButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        UserCredential userCredential = await signInWithGoogle();
                        if (userCredential.user != null) {
                          Map<String, dynamic> userData = {
                            'id': userCredential.user?.uid ?? 'NA',
                            'name': userCredential.user?.displayName ?? 'NA',
                            'email': userCredential.user?.email ?? 'NA',
                          };

                          await SessionService().saveUserData(userData);

                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Login failed"),
                                content: Text("Please try again agter some time."),
                              );
                            },
                          );
                        }

                        print("userCredential: ${userCredential.user.toString()}");
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Login failed"),
                              content: Text(e.toString()),
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Login with google'),
                  )
          ],
        ),
      ),
    );
  }
}
