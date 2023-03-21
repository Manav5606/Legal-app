extension Validator on String {
  bool isValidPhoneNumber() {
    return (int.tryParse(this) is num) && length == 10;
  }

  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool isValidPassword() {
    int charCount = 0;
    int numCount = 0;
    bool hasSpecialCharacter = false;

    for (int i = 0; i < length; i++) {
      if (int.tryParse(this[i]) is num) {
        numCount++;
      } else if (RegExp(r'^[A-Za-z]+$').hasMatch(this[i])) {
        charCount++;
      } else {
        hasSpecialCharacter = true;
      }
    }

    return length >= 8 &&
        charCount >= 4 &&
        numCount >= 4 &&
        !hasSpecialCharacter;
  }
}
