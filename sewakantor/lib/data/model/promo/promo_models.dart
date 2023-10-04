class PromoModels {
  late String promoId;
  late String promoCode;
  late double promoDiscountValue;
  late DateTime promoValidAt;
  late DateTime promoValidUntil;
  late String promoImageBanner;
  PromoModels(
      {required this.promoId,
      required this.promoCode,
      required this.promoDiscountValue,
      required this.promoValidAt,
      required this.promoValidUntil,
      required this.promoImageBanner});
}
