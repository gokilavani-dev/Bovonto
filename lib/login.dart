import 'package:flutter/material.dart';
import 'services/api.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;

  Future<void> performLogin() async {
    final username = userController.text.trim();
    final password = passController.text.trim();
    
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter username & password")));
      return;
    }

    setState(() => loading = true);

    final res = await Api.login(
      username: username,
      password: password,
    );

    setState(() => loading = false);
    if (!mounted) return;
    if (res["ok"] != true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wrong username/password")));
      return;
    }

    // SUCCESS → GO TO HOME
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                label: Text("Username"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: performLogin,
                    child: const Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}
