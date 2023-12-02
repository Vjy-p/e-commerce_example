class CouponModel {
  String couponType;
  String couponCode;
  double? percentage;
  int? flatAmount;
  int minAmount;
  int? maxDiscount;
  CouponModel({
    required this.couponType,
    required this.couponCode,
    this.percentage,
    this.flatAmount,
    required this.minAmount,
    this.maxDiscount,
  });
}
