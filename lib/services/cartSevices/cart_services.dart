class CartServices {
  // Future createCart(body) async {
  //   final response = await http.post(Uri.parse("${Constants.baseUrl}carts/add"),
  //       body: jsonEncode(body));
  //   debugPrint("\nresponse : ${response.body}");
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     debugPrint("\nError ${response.statusCode}");
  //     return null;
  //   }
  // }

  // Future getCartProducts(id) async {
  //   final response = await http.get(Uri.parse("${Constants.baseUrl}carts/$id"));
  //   debugPrint("\nresponse : ${response.body}");
  //   if (response.statusCode == 200) {
  //     return CartModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     debugPrint("\nError ${response.statusCode}");
  //     return null;
  //   }
  // }

  // Future updateCart(id, Map body) async {
  //   final response = await http.put(Uri.parse("${Constants.baseUrl}carts/$id"),
  //       body: jsonEncode(body));
  //   debugPrint("\nresponse : ${response.body}");
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     debugPrint("\nError ${response.statusCode}");
  //     return null;
  //   }
  // }

  // Future RemoveCart(id) async {
  //   final response =
  //       await http.delete(Uri.parse("${Constants.baseUrl}carts/$id"));
  //   debugPrint("\nresponse : ${response.body}");
  //   if (response.statusCode == 200) {
  //     debugPrint("\ndelete : $response");
  //     return jsonDecode(response.body);
  //   } else {
  //     debugPrint("\nError ${response.statusCode}");
  //     return null;
  //   }
  // }
}
