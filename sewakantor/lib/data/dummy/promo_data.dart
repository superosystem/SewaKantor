import 'package:sewakantor/data/model/promo/promo_model.dart';

List<PromoModel> getListOfPromo() {
  return promo;
}

List<PromoModel> promo = [
  PromoModel(
    id: '1',
    imagePromo: 'assets/image_assets/promo_image/promo1.png',
    title: 'Get Vouchers Save up to 80% discount on every first purchase!',
    voucerCode: 'BETTER01',
    expDate: '20 Desember 2022',
    termCondition1:
        'Voucher in the form of a discount of up to 80% for every first use',
    termCondition2: 'Vouchers can be used for 1 transaction',
    termCondition3: 'Vouchers are valid without a minimum transaction',
    termCondition4: 'This voucher cannot be cashed',
    termCondition5:
        'The use of this voucher cannot be combined with other promos',
    promoDescription:
        'Special vouchers for you, enjoy up to 80% discount savings for the first use. Don\'t forget to copy the voucher you have and enter it into the voucher column in the transaction.',
    howToUse1: 'Select the workspace you want to reserve',
    howToUse2: "Press 'Order Now'",
    howToUse3:
        'Enter the payment process then, enter the voucher that you copied on the voucher page.',
    howToUse4:
        'The order fee will automatically be deducted according t, discountValue: nullo the voucher nominal.',
    discountValue: 10,
  ),
  PromoModel(
    id: '2',
    imagePromo: 'assets/image_assets/promo_image/promo2.png',
    title:
        'There\'s something new in February, get the February PROMO full of love',
    voucerCode: 'BCX123',
    expDate: '20 Desember 2022',
    termCondition1:
        'Vouchers in the form of discounts of up to 50% in this month full of love',
    termCondition2: 'Vouchers can be used for 1 transaction',
    termCondition3: 'Vouchers are valid without a minimum transaction',
    termCondition4: 'This voucher cannot be cashed',
    termCondition5:
        'The use of this voucher cannot be combined with other promos',
    promoDescription:
        'Special vouchers for you, enjoy up to 80% discount savings for the first use. Don\'t forget to copy the voucher you have and enter it into the voucher column in the transaction.',
    howToUse1: 'Select the workspace you want to reserve',
    howToUse2: "Press 'Order Now'",
    howToUse3:
        'Enter the payment process then, enter the voucher that you copied on the voucher page.',
    howToUse4:
        'The order fee will automatically be deducted according to the voucher nominal.',
    discountValue: 10,
  ),
  PromoModel(
    id: '3',
    imagePromo: 'assets/image_assets/promo_image/promo3.png',
    title: 'PROMO FRIENDS! Come with friends, the price is getting cheaper',
    voucerCode: 'CDX123',
    expDate: '20 Desember 2022',
    termCondition1:
        'Vouchers in the form of discounts of up to 70% for every transaction with friends',
    termCondition2: 'Vouchers can be used for 1 transaction',
    termCondition3: 'Vouchers are valid without a minimum transaction',
    termCondition4: 'This voucher cannot be cashed',
    termCondition5:
        'The use of this voucher cannot be combined with other promos',
    promoDescription:
        'Special vouchers for you, enjoy up to 80% discount savings for the first use. Don\'t forget to copy the voucher you have and enter it into the voucher column in the transaction.',
    howToUse1: 'Select the workspace you want to reserve',
    howToUse2: "Press 'Order Now'",
    howToUse3:
        'Enter the payment process then, enter the voucher that you copied on the voucher page.',
    howToUse4:
        'The order fee will automatically be deducted according to the voucher nominal.',
    discountValue: 10,
  ),
];
