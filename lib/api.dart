class ApiServices {
  static const baseUrl = 'http://182.93.94.210:8001/api/v1';
  static const allEvents = '$baseUrl/events';
  static const ongoing = '$baseUrl/events/ongoing';
  static const upcoming = '$baseUrl/events/upcoming';
  static const services = '$baseUrl/services';
  static const login = '$baseUrl/login';
  static const register = '$baseUrl/register';
  static const orgRegister = '$baseUrl/org/register';
  static const forgotPassword = '$baseUrl/forget-password';
  static const verify = '$baseUrl/verify-code';
  static const verifyEmail = '$baseUrl/verify-email';
  static const mydetails = '$baseUrl/users/me';
  static const changePassword = '$baseUrl/change-password';
  static const changeDetails = '$baseUrl/update-user';
  static const googleSign = '$baseUrl/login/google';
  static const orgGoogleSign = '$baseUrl/org/login/google';
  static String availableStalls(String eventId) =>
      '$baseUrl/stalls/event/$eventId';
  static String stallById(String stallId) => '$baseUrl/stalls/$stallId';
  static String stallBooking = '$baseUrl/bookings';
  static String multipleStallBooking = '$baseUrl/bookings/multiple';
  static String holdStall = '$baseUrl/bookings/hold';
  static String multipleStallHold = '$baseUrl/bookings/multiple/hold';
}
