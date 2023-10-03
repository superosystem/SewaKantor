import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';

class OfficeDummyDataViewModels with ChangeNotifier {
  List<OfficeModels> _listOfOfficeModels = [];

  List<OfficeModels> get listOfOfficeModels => _listOfOfficeModels;

  addRecord(int dataLength) {
    DateTime fakeDate = DateTime.now();
    var fakerInstance = new Faker();
    List<OfficeModels> datainstance = [];
    for (int i = 1; i <= dataLength; i++) {
      datainstance.add(
        OfficeModels(
          officeID: ("office" + i.toString()),
          officeName: fakerInstance.company.name(),
          officeType: i % 2 == 0 ? "office" : "coworking",
          officeLeadImage: fakerInstance.image.image(),
          officeGridImage: [
            fakerInstance.image.image(),
            fakerInstance.image.image(),
            fakerInstance.image.image()
          ],
          officeStarRating: 5,
          officeDescription: fakerInstance.lorem.sentence(),
          officeApproxDistance: i + 50,
          officeArea: i + 2 * (i + 2),
          officePersonCapacity: ((i + 3) / 2) + 100,
          officeOpenTime: fakeDate,
          officeCloseTime: fakeDate,
          officeLocation: OfficeLocation(
            city: fakerInstance.address.city(),
            district: fakerInstance.address.city(),
            officeLatitude: fakerInstance.geo.latitude(),
            officeLongitude: fakerInstance.geo.longitude(),
          ),
          officePricing: OfficePricing(
              officePrice: fakerInstance.randomGenerator.decimal(),
              officePriceUnits: i % 2 == 0 ? "hour" : "month",
              officePricingCurrency: "Rp"),
          listOfOfficeCapcityModels: [
            OfficeCapacityModels(
                capacityIcon: Icon(Icons.add),
                capacityTitle: "dimension",
                capacityValue: fakerInstance.randomGenerator.decimal(),
                capacityUnits: "m")
          ],
          listOfOfficeFacilitiesModels: [
            OfficeFacilitiesModels(
                facilitiesIcon: Icon(Icons.add),
                facilitiesTitle: fakerInstance.lorem.word())
          ],
          listOfOfficeReviewModels: [
            OfficeReviewModels(
                reviewerUserImage: Image.network(
                  fakerInstance.image.image(
                    keywords: ["people"],
                  ),
                ),
                reviewerUserName: fakerInstance.person.name(),
                reviewText: fakerInstance.lorem.sentence(),
                reviewDate: fakeDate,
                reviewStarsCount: 5,
                reviewHelpRateCount: 99 + 1 * 2),
          ],
        ),
      );
    }
    _listOfOfficeModels = datainstance;
  }
}

class OfficeDataDummy {
  List<OfficeModels> listOfOfficeModels = [];
}
