import 'package:flutter/material.dart';
import 'login.dart';
import '../services/api.dart';
import '../services/location.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // COMMON MESSAGE FUNCTION
  void _showMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // CHECK-IN FUNCTION
  Future<void> _doCheckIn() async {
    final result = await LocationService.validateLocation(30);

    if (!mounted) return;

    if (result == "off") return _showMsg("Please turn ON location.");
    if (result == "perm_denied") {
      return _showMsg("Please allow location permission.");
    }
    if (result == "perm_blocked") {
      return _showMsg("Location permission is blocked. Enable it in Settings.");
    }
    if (result == "far") {
      return _showMsg("You must be within 30 meters of the office.");
    }

    final res = await Api.checkIn(widget.username);
    if (!mounted) return;

    if (res["ok"] == true) {
      _showMsg("Checked In Successfully!");
    } else {
      _showMsg("Check-In Failed. Try again.");
    }
  }

  // CHECK-OUT FUNCTION
  Future<void> _doCheckOut() async {
    final result = await LocationService.validateLocation(30);

    if (!mounted) return;

    if (result == "off") return _showMsg("Please turn ON location.");
    if (result == "perm_denied") {
      return _showMsg("Please allow location permission.");
    }
    if (result == "perm_blocked") {
      return _showMsg("Location permission is blocked. Enable it in Settings.");
    }
    if (result == "far") {
      return _showMsg("You must be within 30 meters of the office.");
    }

    final res = await Api.checkOut(widget.username);
    if (!mounted) return;

    if (res["ok"] == true) {
      _showMsg("Checked Out Successfully!");
    } else {
      _showMsg("Check-Out Failed. Try again.");
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR WITH BACK BUTTON → GOES TO LOGIN PAGE
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Back → LoginScreen (Auto login will redirect to HomeScreen instantly)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, ${widget.username}",
              style: TextStyle(
                fontSize: 22,
                color: Colors.purple.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // CHECK-IN (GREEN)
            ElevatedButton(
              onPressed: _doCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Check In",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // CHECK-OUT (RED)
            ElevatedButton(
              onPressed: _doCheckOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Check Out",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
