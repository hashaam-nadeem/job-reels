class AppConstant{
  static const String AppName = 'Workerapp';
  static const String THEME = 'GlowSolarTheme';
  static const double APP_VERSION = 1.0;
  static const int PASSWORD_MIN_LENGTH = 6;
  static const int TEXT_FIELD_MAX_LENGTH = 250;
  static const int DIGIT_TEXT_FIELD_MAX_LENGTH = 4;
  static const double padding =20;
  static const double avatarRadius =35;

  /// Api section

  static const String BASE_URL = 'http://erp.deurali.biz/api/v1';
  static const String SOLAR_EDGE_BASE_URL = 'https://monitoringapi.solaredge.com/';
  static const String LOGIN = '/login';
  static const String LOGOUT = '/logout';
  static const String UPDATE_PROFILE = '/update-profile';
  static const String FETCH_SHIFT_BY_DATE = '/shift?date=';
  static const String FETCH_SHIFT_DETAIL = '/shift-detail?code=';
  static const String DOWNLOAD_IMAGES = '/download-document?id=';
  static const String FETCH_SHIFT = '/shift';
  static const String FETCH_PROFILE = '/profile';
  static const String FETCH_NOTES = '/note';
  static const String FETCH_DOCUMENT = '/document';
  static const String UPDATE_STATUS = '/update-shift-status';
  static const String CLIENT_DETAILS = '/client-detail/';



  ///share key

  static const String LOGIN_USER = 'LoginUser';
  static const String FCM_TOKEN = 'FcmToken';
  static const String DEFAULT_SOLAR_ID = 'defaultSolarId';
  static const String LOCATION = 'Location';
  static const String COUNTRY_CODE = 'GlowSolarCountryCode';
  static const String LANGUAGE_CODE = 'GlowSolarLanguageCode';
  static const String USER_PASSWORD = 'WorkerAppUserPassword';
  static const String USER_ADDRESS = 'GlowSolarUserAddress';
  static const String USER_MAIL = 'WorkerAppUserMail';
  static const String USER_COUNTRY_CODE = 'GlowSolarUserCountryCode';
  static const String NOTIFICATION = 'GlowSolarNotification';
  static const String SEARCH_HISTORY = 'GlowSolarSearchHistory';
  static const String INTRO = 'GlowSolarIntro';
  static const String NOTIFICATION_COUNT = 'GlowSolarNotificationCount';

  static const List<String> MonthsInYear = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}