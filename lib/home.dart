import 'package:flutter/material.dart';
import 'services/api.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, $username",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                
                final res = await Api.checkIn(username);
                if (!context.mounted) return;
                if (res["ok"] == true) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Checked In")));
                }
              },
              child: const Text("Check In"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final res = await Api.checkOut(username);
                if (!context.mounted) return;
                if (res["ok"] == true) {                             
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Checked Out")));
                }
              },
              child: const Text("Check Out"),
            ),
          ],
        ),
      ),
    );
  }
}
