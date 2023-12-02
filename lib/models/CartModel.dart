class CartModel {
  CartModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.thumbnail,
    required this.quantity,
  });
  late final int id;
  late final String title;
  late final int price;
  late final double discountPercentage;
  late final double? rating;
  late final String brand;
  late final String thumbnail;
  late int quantity;

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    rating = json['rating'];
    brand = json['brand'];
    thumbnail = json['thumbnail'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['price'] = price;
    _data['discountPercentage'] = discountPercentage;
    _data['rating'] = rating;
    _data['brand'] = brand;
    _data['thumbnail'] = thumbnail;
    _data['quantity'] = quantity;
    return _data;
  }
}
