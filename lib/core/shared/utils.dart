class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email zorunlu';
    }

    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Email geçersiz';
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Şifre zorunlu';
    }

    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }

    return null;
  }

  static String? validateRequired({
    required String value,
    required String fieldName,
  }) {
    if (value.isEmpty) {
      return '$fieldName zorunlu';
    }

    return null;
  }

  static String? validateAreaCode(String value) {
    if (value.isEmpty) {
      return 'Alan kodu giriniz';
    }

    if (!value.startsWith('+')) {
      return 'Alan kodu + ile başlamalı';
    }

    if (value.length > 3) {
      return 'Alan kodu en fazla 3 karakter olmalı';
    }

    return null;
  }

  static String? validatePhone(String value) {
    if (value.isEmpty) {
      return 'Telefon zorunlu';
    }

    if (value.length > 10) {
      return 'Telefon en fazla 10 karakter olmalı';
    }

    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Telefon geçersiz';
    }

    return null;
  }
}
