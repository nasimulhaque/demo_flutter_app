class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    if (value.length < 10) {
      return 'Please enter complete address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Enter valid phone number';
    }
    return null;
  }

  static String? validateCoupon(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Coupon is optional
    }
    // Demo coupon codes
    if (value.toUpperCase() == 'SAVE10') {
      return null;
    }
    if (value.toUpperCase() == 'WELCOME20') {
      return null;
    }
    return 'Invalid coupon code';
  }

  static double applyCoupon(String coupon, double total) {
    switch (coupon.toUpperCase()) {
      case 'SAVE10':
        return total * 0.9;
      case 'WELCOME20':
        return total * 0.8;
      default:
        return total;
    }
  }
}