class SampleSearchModel {
  String officeId,
      areaLocation,
      name,
      officeCategory,
      officeBuildingArea,
      officeImage;
  double officeRanting;
  int totalBooking;
  late String? dateSelected;

  SampleSearchModel({
    required this.officeId,
    required this.areaLocation,
    required this.name,
    required this.officeCategory,
    required this.officeBuildingArea,
    required this.officeImage,
    required this.officeRanting,
    required this.totalBooking,
    this.dateSelected,
  });
}
