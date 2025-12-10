import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
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

  @override
  void initState() {
    super.initState();
    autoLoginCheck();
  }

  // AUTO LOGIN IF ALREADY LOGGED IN
  Future<void> autoLoginCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool("loggedIn") ?? false;
    final username = prefs.getString("username") ?? "";
    if (!mounted) return;
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
      );
    }
  }

  // LOGIN FUNCTION
  Future<void> performLogin() async {
    final username = userController.text.trim();
    final password = passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter username & password")),
      );
      return;
    }

    setState(() => loading = true);

    final res = await Api.login(username: username, password: password);

    setState(() => loading = false);

    if (!mounted) return;

    if (res["ok"] != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Wrong username/password")));
      return;
    }

    // SAVE LOGIN STATUS
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loggedIn", true);
    await prefs.setString("username", username);
    if (!mounted) return;
    // GO TO HOME
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // LOGO
              Image.asset("assets/images/bovonto.jpg", height: 120),

              const SizedBox(height: 20),

              // FORM CARD
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Text(
                      "Employee Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.purple.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.purple.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: performLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
