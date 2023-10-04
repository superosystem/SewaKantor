import 'package:flutter/cupertino.dart';
import 'package:sewakantor/data/model/onboard/onboarding_model.dart';
import 'package:sewakantor/data/dummy/onboarding_data.dart';

class OnboardViewModels with ChangeNotifier {
  final List<OnboardingModel> _onboardList = onboarding;

  List get onboardList => _onboardList;

  bool _lastPage = false;

  bool get lastPage => _lastPage;

  set lastPage(index) {
    _lastPage = index;
  }

  void getStarted(index) {
    _lastPage = index;
    notifyListeners();
  }
}
