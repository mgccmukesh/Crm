class ApiConstants {
  static const String baseUrl = 'https://need24.in';
  static const String apiPath = '/api/mobile';
  
  // Auth endpoints
  static const String login = '$apiPath/login';
  static const String logout = '$apiPath/logout';
  static const String me = '$apiPath/me';
  
  // Leads endpoints
  static const String leads = '$apiPath/leads';
  static String leadDetail(dynamic id) => '$apiPath/leads/$id';
  static String leadNotes(dynamic id) => '$apiPath/leads/$id/notes';
  static String leadStatus(dynamic id) => '$apiPath/leads/$id/status';
  
  // Call logging
  static const String callLog = '$apiPath/calls/log';
}
