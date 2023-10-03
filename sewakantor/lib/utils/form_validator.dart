class FormValidator {
  /// validate with confirm password
  static String? validate({
    String? value1,
    String? value2,
    required String title,
  }) {
    if (value1!.isEmpty) {
      return 'Please enter passwords';
    } else if (value1.length > 25) {
      return 'Please enter $title in range of 8 - 25 characters';
    } else if (value1.length < 8) {
      return '$title must be longer than 8 characters';
    } else if (!RegExp(".*[0-9].*").hasMatch(value1)) {
      return '$title should contain a numeric value 1-9';
    }
    // else if (!RegExp('.*[a-z].*').hasMatch(value1)) {
    //   return '$title should contain a lowercase letter a-z';
    // }
    else if (RegExp('.*[A-Z].*').hasMatch(value1)) {
      return '$title only lowercase letters are allowed';
    } else if (value2 != value1) {
      return 'Please enter confirm $title that match';
    }
    return null;
  }

  /// single validate
  static String? validateProfilName({
    String? value1,
    required String title,
  }) {
    if (value1!.isEmpty) {
      return 'Please enter some text';
    } else if (value1.length < 5) {
      return '$title must be longer than 5 characters';
    } else if (!RegExp('.*[a-z].*').hasMatch(value1)) {
      return '$title should contain a lowercase letter a-z';
    } else if (!RegExp('.*[A-Z].*').hasMatch(value1)) {
      return '$title should contain an uppercase letter A-Z';
    }
    return null;
  }

  /// single password validator
  static String? singlePasswordValidator({
    String? value1,
    required String title,
  }) {
    if (value1!.isEmpty) {
      return 'Please enter password';
    } else if (value1.length < 8) {
      return '$title must be longer than 8 characters';
    } else if (value1.length > 25) {
      return 'Please enter $title in range of 8 - 25 characters';
    } else if (!RegExp(".*[0-9].*").hasMatch(value1)) {
      return '$title should contain a numeric value 1-9';
    }
    return null;
  }
}
