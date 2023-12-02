import 'dart:convert';

import 'package:firebase_testing/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatServices {
  static Future getData({pageNumber, dataLimit}) async {
    final response = await http.get(
        Uri.parse("${Constants.baseUrl}/page=$pageNumber&limit=$dataLimit"));
    debugPrint("\nresponse : ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint("\nError ${response.statusCode}");
      return null;
    }
  }
}
