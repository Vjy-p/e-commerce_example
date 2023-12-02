import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_testing/models/Products_Model.dart';
import 'package:firebase_testing/utils/constants.dart';

class CategoryServices {
  Future getAllCategories() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.baseUrl}products/categories'));
      if (response.statusCode == 200) {
        debugPrint("\nresponse : ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        debugPrint("\nError ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("\ncatch Error $e");
      return null;
    }
  }

  Future getCategory(category) async {
    final response = await http
        .get(Uri.parse('${Constants.baseUrl}products/category/$category'));
    debugPrint("response : ${response.body}");
    if (response.statusCode == 200) {
      return ProductsModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint('\nError ${response.statusCode}');
      return null;
    }
  }
}
