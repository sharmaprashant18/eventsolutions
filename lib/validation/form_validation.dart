import 'package:flutter/services.dart';

class MyValidation {
  // Number-only formatter (limits to digits only)
  static List<TextInputFormatter> numberOnly = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4), // Modify length as needed
  ];

  // Email format validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r"^[a-z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation (minimum length 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // Corrected regex pattern without the /pre> at the end
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}$';

    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid Password';
    }

    // This check is redundant since the regex already ensures 8+ characters
    // But keeping it for clarity
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }

    return null;
  }

  // Name validation (checks if not empty)
  // static String? validateName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your name';
  //   }

  //   String pattern = r'^[A-Za-z]+(?:\s[A-Za-z]+)?$';
  //   RegExp regex = RegExp(pattern);
  //   if (!regex.hasMatch(value)) {
  //     return 'Please enter a valid name';
  //   }
  //   return null;
  // }

  // Mobile number format validation
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }
    String pattern =
        r"^(\+?\d{1,3}[-\s]?)?\d{10}$"; // Adjust pattern to match your country's phone format
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  // Date format (e.g., dd/mm/yyyy)
  static List<TextInputFormatter> dateFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
    LengthLimitingTextInputFormatter(3),
  ];
}
