import 'package:flutter/material.dart';

class AddReviewViewModel with ChangeNotifier {
  late int maximumRating = 5;

  int currentRating = 0;

  changedRanting(int index) {
    currentRating = index + 1;
    notifyListeners();
  }
}
