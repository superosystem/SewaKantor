import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/src/model/promo_model.dart';
import 'package:sewakantor/data/model/users/user_models.dart';
import 'package:intl/intl.dart';

class TransactionBookingTime {
  late String checkInHour;
  late String checkInDate;
  String? checkOutHour;
  String? checkOutDate;
  String? transactionCreatedAt;
  DateTime? checkInDateTime;
  DateTime? checkOutDateTime;
  TransactionBookingTime(
      {required this.checkInHour,
      required this.checkInDate,
      this.checkOutHour,
      this.checkOutDate,
      this.transactionCreatedAt,
      this.checkInDateTime,
      this.checkOutDateTime});
}

class PaymentMenthodModel {
  late String paymentId;
  late String paymentMethodName;
  late String paymentMethodImageSlug;
  String? paymentVirtualAccount;
  String? qrGenerateable;
  double? paymentFees;
  PaymentMenthodModel(
      {required this.paymentId,
      required this.paymentMethodName,
      required this.paymentMethodImageSlug,
      this.paymentVirtualAccount,
      this.qrGenerateable,
      this.paymentFees});
}

class PaymentModels {
  List<PaymentMenthodModel> listOfAvailablePaymentMethod = [];
  PaymentModels() {
    listOfAvailablePaymentMethod = [
      PaymentMenthodModel(
          paymentId: "QR",
          paymentMethodName: "QRIS",
          qrGenerateable: "mock%payment%string%for%generated%qr",
          paymentMethodImageSlug: 'assets/image_assets/qris_payment.png',
          paymentFees: 0),
      PaymentMenthodModel(
          paymentId: "BNI_VA",
          paymentMethodName: "BNI",
          paymentVirtualAccount: "0000199911111",
          paymentMethodImageSlug: 'assets/image_assets/bni_payment.png',
          paymentFees: 2500),
      PaymentMenthodModel(
          paymentId: "BRI_VA",
          paymentMethodName: "BRI",
          paymentVirtualAccount: "0120199911111",
          paymentMethodImageSlug: 'assets/image_assets/bri_payment.png',
          paymentFees: 2500),
      PaymentMenthodModel(
          paymentId: "BCA_VA",
          paymentMethodName: "BCA",
          paymentVirtualAccount: "4500199911111",
          paymentMethodImageSlug: 'assets/image_assets/bca_payment.png',
          paymentFees: 2500),
      PaymentMenthodModel(
          paymentId: "MANDIRI_VA",
          paymentMethodName: "MANDIRI",
          paymentVirtualAccount: "6650199911111",
          paymentMethodImageSlug: 'assets/image_assets/mandiri_payment.png',
          paymentFees: 2500),
      PaymentMenthodModel(
          paymentId: "OTHER_VA",
          paymentMethodName: "OTHER",
          paymentVirtualAccount: "3350199911111",
          paymentMethodImageSlug: 'assets/image_assets/other_payment.png',
          paymentFees: 5000),
    ];
  }

  PaymentMenthodModel paymentMethodFilters(
      {required String requestedPaymentMethodId}) {
    //filters will return the respected payment method models if the requestedId's is exist on ListOfAvailablePaymentMethod,
    //else it will return the last element of ListOfAvailablePaymentMethod
    PaymentMenthodModel filteredPaymentModel =
        listOfAvailablePaymentMethod.last;
    listOfAvailablePaymentMethod.forEach((element) {
      if (element.paymentId == requestedPaymentMethodId) {
        filteredPaymentModel = element;
      }
    });
    return filteredPaymentModel;
  }
}

class TransactionFormModels {
  late int transactionTotalPrice;
  late TransactionBookingTime transactionBookingTime;
  late int duration;
  late String selectedDrink;
  late int selectedOfficeId;
  OfficeModels? officeData;
  PromoModel? usedPromo;
  TransactionFormModels(
      {required this.transactionTotalPrice,
      required this.transactionBookingTime,
      required this.duration,
      required this.selectedDrink,
      required this.selectedOfficeId,
      this.officeData,
      this.usedPromo});
}

class CreateTransactionModels {
  late int transactionTotalPrice;
  late TransactionBookingTime transactionBookingTime;
  late int duration;
  late String paymentMethodName;
  late String selectedDrink;
  late int selectedOfficeId;
  OfficeModels? officeData;
  CreateTransactionModels(
      {required this.transactionTotalPrice,
      required this.transactionBookingTime,
      required this.duration,
      required this.paymentMethodName,
      required this.selectedDrink,
      required this.selectedOfficeId,
      this.officeData});
}

class UserTransaction {
  late int bookingId;
  late int bookingDuration;
  late TransactionBookingTime bookingTime;
  late int bookingOfficePrice;
  late String Drink;
  late String Status;
  late PaymentMenthodModel paymentMethod;
  late UserModel userData;
  OfficeModels? officeData;
  UserTransaction({
    required this.bookingId,
    required this.bookingDuration,
    required this.bookingTime,
    required this.bookingOfficePrice,
    required this.Drink,
    required this.Status,
    required this.paymentMethod,
    required this.userData,
    this.officeData,
  });
}

class ReservationDetailModel {
  late String iconSlug;
  late String detailData;
  ReservationDetailModel({required this.iconSlug, required this.detailData});
}

class ReservationDetails {
  List<ReservationDetailModel> _reservationDetail = [];
  List<ReservationDetailModel> get reservationDetailData => _reservationDetail;
  ReservationDetails(
      {required String userName,
      required DateTime checkInDate,
      required String checkInTime,
      required String checkOutTime,
      required int duration,
      required String durationUnit,
      required String requestedDrink}) {
    _reservationDetail = [
      ReservationDetailModel(
          iconSlug: "account_outlined_normal", detailData: userName),
      ReservationDetailModel(
          iconSlug: "calendar_outlined_normal",
          detailData: DateFormat('EEEE, d MMMM yyyy').format(checkInDate)),
      ReservationDetailModel(
          iconSlug: "clock_outlined_normal",
          detailData: "$checkInTime - $checkOutTime ($duration $durationUnit)"),
      ReservationDetailModel(
          iconSlug: "drink_outlined_normal", detailData: requestedDrink)
    ];
  }
}
