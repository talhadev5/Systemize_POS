class AppKeys {
  static const String authToken = 'AuthToken';
  static const String uRole = 'UserRole';
  static const String userDetail = 'userDetail';
  static const String appLanguage = 'appLanguage';
}

class ErrorStrings {
  static String someThingWentWrong = 'some thing went wrong';
  static String nameReq = 'Name is Required';
  static String emailReq = 'Email is Required';
  static String emailInvalid = 'Email is Invalid';
  static String passwordReq = 'Password is Required';
  static String passwordMust = 'Password must be at least 8 characters long';
  static String passwordContain =
      'contain Capital, small letter & Number & Special';
  static String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$';

  static String notEmpty = 'Required';
  static String passwordStrong = 'Password is not Strong';
  static String acceptTermAndCondition = 'Accept terms and condition';
}
