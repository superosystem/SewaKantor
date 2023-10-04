//do custom parsing here
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/data/model/users/user_models.dart';
import 'package:sewakantor/data/dummy/promo_data.dart';
import 'package:sewakantor/data/model/promo/promo_model.dart';
import 'package:sewakantor/data/model/reviews/review_models.dart';
import 'package:sewakantor/data/model/transactions/transactions_models.dart';
import 'package:sewakantor/utils/enums.dart';

//helper & formatter parsers
//position to request string formatter
String positionRequestFormatter(
    {required String latitude, required String longitude}) {
  return "lat=" + latitude + "&long=" + longitude;
}

DateTime? parseApiFormatDateTime({required String apiFormattedDateTime}) {
  print(apiFormattedDateTime + "hehehe");
  if (apiFormattedDateTime.length > 3) {
    var splitedDate = apiFormattedDateTime.split("-");
    String day = splitedDate[0];
    String month = splitedDate[1];
    String year = splitedDate[2];
    String time = "00:00:00";
    String formattedDateString = year + month + day + " " + time;
    return DateTime.parse(formattedDateString);
  }
}

DateTime? parseApiFormatDateTime3({required String apiFormattedDateTime}) {
  print(apiFormattedDateTime + "hehehe");
  if (apiFormattedDateTime.length > 3) {
    var currentDate = apiFormattedDateTime.split(" ");
    var splitedDate = currentDate[0].split("-");
    String day = splitedDate[0];
    String month = splitedDate[1];
    String year = splitedDate[2];
    String time = "00:00:00";
    String formattedDateString = year + month + day + " " + time;
    return DateTime.parse(formattedDateString);
  }
}

UserTransaction? parseCreateTransactionToUserTransaction(
    {CreateTransactionModels? requestedModel,
    required UserModel usedUserModel}) {
  if (requestedModel != null) {
    final paymentModel = PaymentModels().listOfAvailablePaymentMethod;
    PaymentMenthodModel? selectedPayment;
    UserTransaction? selectedModel;
    paymentModel.forEach((element) {
      if (element.paymentMethodName == requestedModel.paymentMethodName) {
        selectedPayment = element;
      }
    });
    return selectedModel = UserTransaction(
        officeData: requestedModel.officeData,
        bookingId: 999,
        bookingDuration: requestedModel.duration,
        bookingTime: requestedModel.transactionBookingTime,
        bookingOfficePrice: requestedModel.transactionTotalPrice,
        Drink: requestedModel.selectedDrink,
        Status: "on process",
        paymentMethod: selectedPayment ?? paymentModel.last,
        userData: usedUserModel);
  } else {
    return null;
  }
}

DateTime? parseApiFormatDateTime2({required String apiFormattedDateTime}) {
  if (apiFormattedDateTime.length > 3) {
    var splitedDate = apiFormattedDateTime.split("/");
    String day = splitedDate[0];
    String month = splitedDate[1];
    String year = splitedDate[2];
    String time = "00:00:00";
    String formattedDateString = year + month + day + " " + time;
    return DateTime.parse(formattedDateString);
  }
}

TransactionBookingTime dateTimeParsers(
    {required int selectedHours,
    required DateTime selectedDate,
    required int duration}) {
  String checkInHourFormatted = selectedHours < 10 && selectedHours >= 0
      ? ("0$selectedHours:00")
      : ("$selectedHours:00");
  String checkOutHourFormatted =
      (selectedHours + duration) < 10 && (selectedHours + duration) >= 0
          ? ("0${(selectedHours + duration)}:00")
          : ("${(selectedHours + duration)}:00");
  String dayFormatted = selectedDate.day < 10 && selectedDate.day >= 0
      ? "0${selectedDate.day}"
      : "${selectedDate.day}";
  String monthFormatted = selectedDate.month < 10 && selectedDate.month >= 0
      ? "0${selectedDate.month}"
      : "${selectedDate.month}";
  String dateFormatted = "$dayFormatted/$monthFormatted/${selectedDate.year}";
  print("datetime parse done");
  print(dateFormatted + checkInHourFormatted);
  return TransactionBookingTime(
      checkInHour: checkInHourFormatted,
      checkOutHour: checkOutHourFormatted,
      checkInDate: dateFormatted,
      checkInDateTime: selectedDate);
}

int calculateTotalPrice({
  required double basePrice,
  required int duration,
  int? discount,
}) {
  int totalPrice =
      ((basePrice * duration) - ((basePrice / 100) * (discount ?? 0))).toInt();
  return ((totalPrice + ((totalPrice / 100) * 11).round()) + 10000);
}

//list iterator and filter
//office list iterator
OfficeModels? officeModelFilterByOfficeId(
    {required List<OfficeModels> listOfModels,
    required String requestedOfficeId}) {
  OfficeModels? tempModels;
  print("coba parse all office");
  listOfModels.forEach((element) {
    if (element.officeID == requestedOfficeId) {
      print("parse berhasil");

      tempModels = element;
    }
  });
  return tempModels;
}

PromoModel? filterPromoByCode({required String promoCode}) {
  final listOfPromo = getListOfPromo();
  PromoModel? filteredPromo;
  listOfPromo.forEach((element) {
    if (element.voucerCode == promoCode) {
      print("discount found");
      filteredPromo = element;
    }
  });
  return filteredPromo;
}

//gender enums to string parser
String genderEnumParsers(GenderEnum enumGenders) {
  return enumGenders == GenderEnum.male ? "male" : "female";
}

//api data parsers

UserModel userModelParser(
    Map<String, dynamic> profResponse, UserToken userTokens) {
  return UserModel(
    userId: profResponse["data"]["id"].toString(),
    userEmail: profResponse["data"]["email"],
    userProfileDetails: UserProfileDetail(
        userName: profResponse["data"]["full_name"],
        userProfilePicture: profResponse["data"]["photo"],
        userGender: profResponse["data"]["gender"]),
    userTokens: userTokens,
  );
}

OfficePricing officePricingParsers(
    {required String officeType, required double officePrice}) {
  return OfficePricing(
      officePrice: officePrice,
      officePriceUnits:
          officeType == "Coworking Space" || officeType == "Meeting Room"
              ? "hour"
              : "month",
      officePricingCurrency: "Rp");
}

List<OfficeFacilitiesModels> officeFacilitiesModelsParsers(
    {required List facilitiesModel}) {
  List<OfficeFacilitiesModels> listOfFacilities = [];

  facilitiesModel.forEach((element) {
    listOfFacilities.add(
      OfficeFacilitiesModels(
          facilitiesTitle: element["facilities_desc"],
          facilitiesIconSlug: element["facilities_slug"]),
    );
  });

  return listOfFacilities;
}

List<OfficeCapacityModels> officeCapacityParser(
    {required int capAccomodate,
    required int capWorkingDesk,
    required int capMeetingRoom,
    required int capPrivate_room}) {
  List<String> capacityType = [
    "accomodate",
    "working_desk",
    "meeting_room",
    "private_room"
  ];
  List<String> capacityTitle = [
    "Accomodate",
    "Working Desk",
    "Meeting Room",
    "Private Room"
  ];
  List<String> capacityUnits = ["person", "desk", "room", "room"];
  List<int> capacityValue = [
    capAccomodate,
    capWorkingDesk,
    capMeetingRoom,
    capPrivate_room
  ];
  List<OfficeCapacityModels> listOfCapacity = [];

  for (int index = 0; index < capacityValue.length; index++) {
    if (capacityValue[index] > 0) {
      listOfCapacity.add(
        OfficeCapacityModels(
            capacityIconSlug: capacityType[index],
            capacityTitle: capacityType[index],
            capacityValue: capacityValue[index].toDouble(),
            capacityUnits: capacityUnits[index]),
      );
    }
  }
  return listOfCapacity;
}

List<OfficeModels> officeModelParsers(List<dynamic> listOfficeJson) {
  var fakerInstance = new Faker();
  DateTime currDate = DateTime.now();
  String year = currDate.year.toString();
  String month = currDate.month.toString();
  String days = currDate.day.toString();
  List<OfficeModels> listOfOffice = [];
  listOfficeJson.forEach((jsonResponse) {
    listOfOffice.add(
      OfficeModels(
          officeID: jsonResponse["id"].toString(),
          officeName: jsonResponse["title"],
          officeType: jsonResponse["office_type"],
          officeLeadImage: jsonResponse["images"][1],
          officeGridImage: jsonResponse["images"],
          officeStarRating: jsonResponse["rate"].toDouble(),
          officeDescription: jsonResponse["description"],
          officeApproxDistance: jsonResponse["distance"].toDouble(),
          officeArea: jsonResponse["office_length"].toDouble(),
          officePersonCapacity: jsonResponse["accommodate"].toDouble(),
          officeOpenTime: DateTime.parse(year +
              "-" +
              month +
              "-" +
              days +
              " " +
              jsonResponse["open_hour"] +
              ":00"),
          officeCloseTime: DateTime.parse(year +
              "-" +
              month +
              "-" +
              days +
              " " +
              jsonResponse["close_hour"] +
              ":00"),
          officeLocation: OfficeLocation(
              city: jsonResponse["city"],
              district: jsonResponse["district"],
              officeLatitude: jsonResponse["lat"],
              officeLongitude: jsonResponse["lng"]),
          officePricing: officePricingParsers(
              officeType: jsonResponse["office_type"],
              officePrice: jsonResponse["price"].toDouble()),
          listOfOfficeCapcityModels: officeCapacityParser(
              capAccomodate: jsonResponse["accommodate"],
              capWorkingDesk: jsonResponse["working_desk"],
              capMeetingRoom: jsonResponse["meeting_room"],
              capPrivate_room: jsonResponse["private_room"]),
          listOfOfficeFacilitiesModels: officeFacilitiesModelsParsers(
              facilitiesModel: jsonResponse["facility_model"]),
          listOfOfficeReviewModels: [
            OfficeReviewModels(
                reviewerUserImage: Image.network(
                  fakerInstance.image.image(
                    keywords: ["people"],
                  ),
                ),
                reviewerUserName: fakerInstance.person.name(),
                reviewText: fakerInstance.lorem.sentence(),
                reviewDate: currDate,
                reviewStarsCount: 5,
                reviewHelpRateCount: 99 + 1 * 2),
          ]),
    );
  });

  return listOfOffice;
}

OfficeModels singleOfficeModelParser(Map<String, dynamic> jsonResponse) {
  var fakerInstance = new Faker();
  DateTime currDate = DateTime.now();
  String year = currDate.year.toString();
  String month = currDate.month.toString();
  String days = currDate.day.toString();
  return OfficeModels(
    officeID: jsonResponse["id"].toString(),
    officeName: jsonResponse["title"],
    officeType: jsonResponse["office_type"],
    officeLeadImage: jsonResponse["images"][1],
    officeGridImage: jsonResponse["images"],
    officeStarRating: jsonResponse["rate"].toDouble(),
    officeDescription: jsonResponse["description"],
    officeApproxDistance: jsonResponse["distance"].toDouble(),
    officeArea: jsonResponse["office_length"].toDouble(),
    officePersonCapacity: jsonResponse["accommodate"].toDouble(),
    officeOpenTime: DateTime.parse(year +
        "-" +
        month +
        "-" +
        days +
        " " +
        jsonResponse["open_hour"] +
        ":00"),
    officeCloseTime: DateTime.parse(year +
        "-" +
        month +
        "-" +
        days +
        " " +
        jsonResponse["close_hour"] +
        ":00"),
    officeLocation: OfficeLocation(
        city: jsonResponse["city"],
        district: jsonResponse["district"],
        officeLatitude: jsonResponse["lat"],
        officeLongitude: jsonResponse["lng"]),
    officePricing: officePricingParsers(
        officeType: jsonResponse["office_type"],
        officePrice: jsonResponse["price"].toDouble()),
    listOfOfficeCapcityModels: officeCapacityParser(
        capAccomodate: jsonResponse["accommodate"],
        capWorkingDesk: jsonResponse["working_desk"],
        capMeetingRoom: jsonResponse["meeting_room"],
        capPrivate_room: jsonResponse["private_room"]),
    listOfOfficeFacilitiesModels: officeFacilitiesModelsParsers(
        facilitiesModel: jsonResponse["facility_model"]),
    listOfOfficeReviewModels: [
      OfficeReviewModels(
          reviewerUserImage: Image.network(
            fakerInstance.image.image(
              keywords: ["people"],
            ),
          ),
          reviewerUserName: fakerInstance.person.name(),
          reviewText: fakerInstance.lorem.sentence(),
          reviewDate: currDate,
          reviewStarsCount: 5,
          reviewHelpRateCount: 99 + 1 * 2),
    ],
  );
}

//transaction parser
PaymentMenthodModel? paymentMenthodModelFilter(
    {required String paymentMethodName}) {
  PaymentMenthodModel? PaymentMenthodModelFinalize;
  PaymentModels().listOfAvailablePaymentMethod.forEach((element) {
    if (element.paymentMethodName == paymentMethodName) {
      PaymentMenthodModelFinalize = element;
    }
  });
  return PaymentMenthodModelFinalize;
}

UserTransaction userTransactionParsers(
    {required Map<String, dynamic> jsonResponse,
    required UserModel requestedUserModel,
    required List<OfficeModels> listOfficeModels}) {
  return UserTransaction(
      bookingId: jsonResponse["id"],
      bookingDuration: jsonResponse["duration"],
      bookingTime: TransactionBookingTime(
          checkInHour: jsonResponse["check_in"]["time"],
          checkInDate: jsonResponse["check_in"]["date"]),
      bookingOfficePrice: jsonResponse["price"],
      Drink: jsonResponse["drink"],
      Status: jsonResponse["status"],
      paymentMethod: paymentMenthodModelFilter(
              paymentMethodName: jsonResponse["payment_method"]) ??
          PaymentModels().listOfAvailablePaymentMethod.last,
      userData: requestedUserModel,
      officeData: officeModelFilterByOfficeId(
          listOfModels: listOfficeModels,
          requestedOfficeId: (jsonResponse["office"]["office_id"]).toString()));
}

List<UserTransaction> listedUserTransactionParser(
    {required List requestedResponses,
    required UserModel requestedUserModel,
    required List<OfficeModels> listOfOfficeModels}) {
  List<UserTransaction> finalizeParser = [];
  requestedResponses.forEach((element) {
    finalizeParser.add(userTransactionParsers(
        jsonResponse: element,
        requestedUserModel: requestedUserModel,
        listOfficeModels: listOfOfficeModels));
  });
  return finalizeParser;
}

ReviewModels reviewModelParser(Map<String, dynamic> jsonResponse) {
  print(jsonResponse["created_at"]);
  return ReviewModels(
      reviewComment: jsonResponse["comment"],
      reviewRating: jsonResponse["score"].toDouble(),
      reviewedOfficeId: jsonResponse["office"]["office_id"],
      reviewId: jsonResponse["id"],
      userId: jsonResponse["user"]["user_id"],
      createdAt: parseApiFormatDateTime3(
          apiFormattedDateTime: jsonResponse["created_at"]));
}

List<ReviewModels> listOfReviewModelParser({required List listOfResponse}) {
  List<ReviewModels> parsedList = [];
  listOfResponse.forEach((element) {
    parsedList.add(reviewModelParser(element));
  });
  return parsedList;
}
