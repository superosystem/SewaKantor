class BeverageModels {
  late int drinkId;
  late String imagePath;
  late String drinkName;
  late String drinkDescription;
  BeverageModels(
      {required this.drinkId,
      required this.imagePath,
      required this.drinkName,
      required this.drinkDescription});
}

List<BeverageModels> listOfBeverages() {
  return [
    BeverageModels(
        drinkId: 1,
        imagePath: "assets/image_assets/beverages_image/beverage1.png",
        drinkName: "Hot Chocolate",
        drinkDescription: "Hot chocolate can warm the body from cold air"),
    BeverageModels(
        drinkId: 2,
        imagePath: "assets/image_assets/beverages_image/beverage2.png",
        drinkName: "Iced Coffe Brown Sugar",
        drinkDescription:
            "Iced coffee made using natural brown sugar so it's healthy"),
    BeverageModels(
        drinkId: 3,
        imagePath: "assets/image_assets/beverages_image/beverage3.png",
        drinkName: "Iced Lemon Tea",
        drinkDescription:
            "Very refreshing for the throat with a sour lemon taste"),
  ];
}
