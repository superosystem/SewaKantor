import 'package:flutter/material.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionViewModel with ChangeNotifier {
  /// virtual transfer metod
  final PaymentMetodEnum _virtualAccountMetod = PaymentMetodEnum.qris;

  /// bank transfer method
  final List<PaymentMetodEnum> _bankTransferMetod = [
    PaymentMetodEnum.bca,
    PaymentMetodEnum.bni,
    PaymentMetodEnum.bri,
    PaymentMetodEnum.mandiri,
    PaymentMetodEnum.other,
  ];

  get virtualAccountMetod => _virtualAccountMetod;

  get bankTransferMetod => _bankTransferMetod;

  final List _itemTransaction = [
    [
      'assets/image_assets/bca_payment.png',
      'BCA (Bank Central Asia)',
    ],
    [
      'assets/image_assets/bni_payment.png',
      'BNI (Bank Nasional Indonesia)',
    ],
    [
      'assets/image_assets/bri_payment.png',
      'BRI (Bank Republik Indonesia)',
    ],
    [
      'assets/image_assets/mandiri_payment.png',
      'Bank Mandiri',
    ],
    [
      'assets/image_assets/other_payment.png',
      'Transfer Bank Lain ',
    ],
  ];

  get itemTransaction => _itemTransaction;

  /// ------------------------------------------------------------------------
  /// payment detail view model

  bool _dropDown1 = false;

  get dropDown1 => _dropDown1;

  void isDropDown() {
    _dropDown1 = !_dropDown1;
    notifyListeners();
  }

  bool paymentATM = false;

  /// bool only to payment via atm
  void paymentViaATM() {
    paymentATM = !paymentATM;
    notifyListeners();
  }

  bool paymentMBank = false;

  /// bool only to payment via m banking
  void paymentViaMBank() {
    paymentMBank = !paymentMBank;
    notifyListeners();
  }

  /// button need help in payment detail
  /// launch whatsapp external (aida)
  Future<void> launchWA() async {
    if (!await launchUrl(
      Uri.parse('https://wa.me/6282215126377'),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch';
    }
  }
}
