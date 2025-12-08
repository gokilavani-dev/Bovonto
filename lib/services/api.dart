import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// ⭐ Your Vercel Proxy URL
const String proxyBase =
    "https://gas-proxy-8lasy44pi-gokilavani-devs-projects.vercel.app/api/proxy?url=";

// ⭐ Your Google Apps Script Exec URL
const String gasUrl =
    "https://script.google.com/macros/s/AKfycbzCS5QaT7RdwowdpccJObq4mOxQNV_-T-bwNH64OP4iG3OwcEkDx5Y0w20WSh1PrqoibQ/exec";

class Api {
  // ---------------- LOGIN ----------------
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final String target =
        "$gasUrl?action=login&username=$username&password=$password";

    final Uri uri = Uri.parse(proxyBase + Uri.encodeComponent(target));

    debugPrint("🔵 LOGIN URL = $uri");

    final res = await http.get(uri);

    debugPrint("🟢 LOGIN RESPONSE = ${res.body}");

    try {
      return jsonDecode(res.body);
    } catch (_) {
      return {"ok": false, "error": "invalid_json", "raw": res.body};
    }
  }

  // ---------------- CHECK-IN ----------------
  static Future<Map<String, dynamic>> checkIn(String username) async {
    final String target = "$gasUrl?action=checkin&username=$username";
    final Uri uri = Uri.parse(proxyBase + Uri.encodeComponent(target));

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
    final String target = "$gasUrl?action=checkout&username=$username";
    final Uri uri = Uri.parse(proxyBase + Uri.encodeComponent(target));

    final res = await http.get(uri);
    debugPrint("🟢 CHECK-OUT = ${res.body}");

    try {
      return jsonDecode(res.body);
    } catch (_) {
      return {"ok": false};
    }
  }
}
