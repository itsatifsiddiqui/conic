class Validators {
  static String? emptyValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please Fill in the field';
    }
    return null;
  }

  static String? priceValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please Fill in the field';
    }

    try {
      double.parse(text);
      return null;
    } catch (e) {
      return 'Please enter correct price';
    }
  }

  static String? emailValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please Fill in the email';
    }

    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(p);

    if (!regExp.hasMatch(email.trim())) {
      return 'Please Enter Valid Email Address';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Please fill in the password';
    }

    if (password.length < 6) {
      return 'Password length must be atleast 6 chrachters.';
    }
    return null;
  }

  static String? descriptionValidator(String description) {
    if (description.isEmpty) {
      return 'Description Is Required';
    }

    if (description.length < 5) {
      return 'Description must be atleast 5 chrachters.';
    }
    return null;
  }
}
