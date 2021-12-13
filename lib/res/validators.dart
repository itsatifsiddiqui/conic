class Validators {
  static String? emptyValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please fill in the field';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please fill in the email';
    }

    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(p);

    if (!regExp.hasMatch(email.trim())) {
      return 'Please enter valid email address';
    }
    return null;
  }

  static String? usernameValidator(String? username) {
    if (username!.isEmpty) {
      return 'Please fill in the username';
    }

    if (username.length < 6) {
      return 'username must be atleast 6 chrachters.';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Please fill in the password';
    }

    const p = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

    final regExp = RegExp(p);

    if (!regExp.hasMatch(password.trim())) {
      return 'Please must be at least 8 chracters, one uppercase, one lowercase, one number and one special chracter.';
    }
    return null;
  }

  static String? descriptionValidator(String description) {
    if (description.isEmpty) {
      return 'Description is required';
    }

    if (description.length < 5) {
      return 'Description must be atleast 5 chrachters.';
    }
    return null;
  }
}
