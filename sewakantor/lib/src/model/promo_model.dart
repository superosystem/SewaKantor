class PromoModel {
  String id,
      imagePromo,
      title,
      voucerCode,
      expDate,
      termCondition1,
      termCondition2,
      termCondition3,
      termCondition4,
      termCondition5,
      promoDescription,
      howToUse1,
      howToUse2,
      howToUse3,
      howToUse4;

  int? discountValue;

  PromoModel({
    required this.id,
    required this.imagePromo,
    required this.title,
    required this.voucerCode,
    required this.expDate,
    required this.termCondition1,
    required this.termCondition2,
    required this.termCondition3,
    required this.termCondition4,
    required this.termCondition5,
    required this.promoDescription,
    required this.howToUse1,
    required this.howToUse2,
    required this.howToUse3,
    required this.howToUse4,
    required this.discountValue,
  });
}
