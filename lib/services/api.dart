import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; //contains debugPrint
// ⚠ YOUR NEW WEB APP URL HERE
const String baseUrl =
    "https://script.google.com/macros/s/AKfycbzCS5QaT7RdwowdpccJObq4mOxQNV_-T-bwNH64OP4iG3OwcEkDx5Y0w20WSh1PrqoibQ/exec";

class Api {
  // ---------------- LOGIN ----------------
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse(
        "$baseUrl?action=login&username=$username&password=$password");

    final res = await http.get(uri);
    debugPrint("🔵 LOGIN URL = $uri");
    debugPrint("🟢 LOGIN RESPONSE = ${res.body}");

    try {
      return jsonDecode(res.body);
    } catch (_) {
      return {"ok": false, "error": "invalid_json", "raw": res.body};
    }
  }

  // ---------------- CHECK-IN ----------------
  static Future<Map<String, dynamic>> checkIn(String username) async {
    final uri = Uri.parse("$baseUrl?action=checkin&username=$username");

    final res = await http.get(uri);
    debugPrint("🟢 CHECK-IN = ${res.body}");

    try {
      return jsonDecode(res.body);
    } catch (_) {
      return {"ok": false};
    }
  }

  // ---------------- CHECK-OUT ----------------
  static Future<Map<String, dynamic>> checkOut(String username) async {
    final uri = Uri.parse("$baseUrl?action=checkout&username=$username");

    final res = await http.get(uri);
    debugPrint("🟢 CHECK-OUT = ${res.body}");

    try {
      return jsonDecode(res.body);
    } catch (_) {
      return {"ok": false};
    }
  }
}
