import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';

class LoginViewModel with ChangeNotifier {
  bool _isLoading = false;

  get isLoading => _isLoading;

  void userLogin(context) async {
    _isLoading = !_isLoading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));
    _isLoading = false;
    notifyListeners();
    Provider.of<NavigasiViewModel>(context, listen: false)
        .navigasiToMenuScreen(context);
  }

  /// visible password
  bool _visiblePassword1 = false;

  bool _visiblePassword2 = false;

  get visiblePassword1 => _visiblePassword1;

  get visiblePassword2 => _visiblePassword2;

  void visiblePass1() {
    _visiblePassword1 = !_visiblePassword1;
    notifyListeners();
  }

  void visiblePass2() {
    _visiblePassword2 = !_visiblePassword2;
    notifyListeners();
  }
}
