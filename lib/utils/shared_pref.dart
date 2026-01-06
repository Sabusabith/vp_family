import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Save any object (String, bool, int, double, List<String>)
Future<void> saveObject(String key, dynamic value) async {
  final sp = await SharedPreferences.getInstance();

  if (value is String) {
    await sp.setString(key, value);
  } else if (value is int) {
    await sp.setInt(key, value);
  } else if (value is bool) {
    await sp.setBool(key, value);
  } else if (value is double) {
    await sp.setDouble(key, value);
  } else if (value is List<String>) {
    await sp.setStringList(key, value);
  } else {
    throw Exception("Unsupported type for SharedPreferences");
  }
}

/// Get any type of object
Future<dynamic> getSavedObject(String key) async {
  final sp = await SharedPreferences.getInstance();
  return sp.get(key); // Returns dynamic (String, bool, int, etc.)
}

/// Clear saved value
Future<void> clearSavedObject(String key) async {
  final sp = await SharedPreferences.getInstance();
  await sp.remove(key);
}
