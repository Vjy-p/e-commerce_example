import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_testing/models/Products_Model.dart';
import 'package:firebase_testing/models/Single_Product_Model.dart';
import 'package:firebase_testing/utils/constants.dart';

class ProductsServices {
  Future getAllProducts() async {
    // final response = await http.get(Uri.parse(Constants.baseUrl + "products"));
    // debugPrint("\nresponse : ${response.body}");
    // if (response.statusCode == 200) {
    //   return ProductsModel.fromJson(jsonDecode(response.body));
    // } else {
    //   debugPrint("\nError ${response.statusCode}");
    //   return null;
    // }
    final response =
        await http.get(Uri.parse("${Constants.baseUrl}products?limit=10"));
    debugPrint("\nresponse : ${response.body}");
    if (response.statusCode == 200) {
      return ProductsModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint("\nError ${response.statusCode}");
      return null;
    }
  }

  Future getProduct(id) async {
    final response =
        await http.get(Uri.parse("${Constants.baseUrl}products/$id"));
    debugPrint("\nresponse : ${response.body}");
    if (response.statusCode == 200) {
      return SingleProductModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint("\nError ${response.statusCode}");
      return null;
    }
  }

  Future getSearchData(search) async {
    final response = await http
        .get(Uri.parse("${Constants.baseUrl}products/search?q=$search"));
    debugPrint("\nresponse : ${response.body}");
    if (response.statusCode == 200) {
      return ProductsModel.fromJson(jsonDecode(response.body));
    } else {
      debugPrint("\nError ${response.statusCode}");
      return null;
    }
  }
}
