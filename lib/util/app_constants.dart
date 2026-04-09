import 'package:glow_solar/data/model/response/car_model.dart';
import 'package:glow_solar/data/model/response/charger_model.dart';
import 'package:glow_solar/enums/time_line.dart';
import 'package:glow_solar/util/images.dart';
import '../data/model/response/language_model.dart';
import 'app_strings.dart';

class AppConstants {
  static const String APP_NAME = 'Glow Solar';
  static const double APP_VERSION = 1.0;
  static const int PASSWORD_MIN_LENGTH = 6;
  static const int TEXT_FIELD_MAX_LENGTH = 250;
  static const int DIGIT_TEXT_FIELD_MAX_LENGTH = 4;
  static const double padding =20;
  static const double avatarRadius =35;

  /// Api section

  static const String BASE_URL = 'http://3.219.205.9';
  // static const String BASE_URL = 'http://gahhak-stagging.link/solar-glow-backend-laravel';
  static const String SMARTCAR_BASE_URL = 'https://connect.smartcar.com/';
  static const String SMARTCAR_API_BASE_URL = 'https://api.smartcar.com/';
  static const String AUTH_SMARTCAR_BASE_URL = 'https://auth.smartcar.com/';
  static const String SOLAR_EDGE_BASE_URL = 'https://monitoringapi.solaredge.com/';
  static const String SERVER_STORAGE_URL = '$BASE_URL/storage/app/public/';
  static const String AUTH = '/api/auth/';
  static const String SOLAR = '/api/solar/';
  static const String CHARGER = '/api/charger/';
  static const String CAR = '/api/car/';
  static const String PASSWORD = '/api/password/';
  static const String REQUEST = '/api/charging-request/';
  static const String NOTIFICATIONS = '/api/notification/';
  static const String INVOICEHISTORY = '/api/payment-history/';
  static const String LOGIN = '${AUTH}login';
  static const String UPDATE_FCM_TOKEN = '${AUTH}add-fcm-token';
  static const String SIGNUP = '${AUTH}signup';
  static const String LOGOUT = '${AUTH}logout';
  static const String FORGET = '${PASSWORD}forgot';
  static const String RESET = '${PASSWORD}reset';
  static const String CHANGE_PASSWORD = '${PASSWORD}change';
  static const String OTP_VERIFy = '/api/otp-code/verify';
  static const String REGISTER_OTP_VERIFY = '${AUTH}verify';
  static const String ADD_SOLAR = '${SOLAR}add';
  static const String FETCH_SOLAR_LIST = '${SOLAR}list';
  static const String FETCH_SOLAR_PRODUCTION = 'site/';
  static const String FETCH_CHARGER_Api = 'https://fr.wydq.tech/weeyuen/api.php/interface';
  static const String FETCH_CHARGER_WITH_PILENO = '/realdata';
  static const String UPDATE_SOLAR = '${SOLAR}update/';
  static const String DELETE_SOLAR = '${SOLAR}delete/';
  static const String ADD_CHARGER = '${CHARGER}add';
  static const String FETCH_CHARGER_LIST = '${CHARGER}list';
  static const String UPDATE_CHARGER = '${CHARGER}update/';
  static const String UPDATE_IS_Active_CHARGER = '${CHARGER}update-is-active/';
  static const String FETCH_FIND_CHARGER = '${CHARGER}find';
  static const String ADD_REQUEST_CHARGER = '${REQUEST}add';
  static const String FETCH_REQUEST_CHARGER = '${REQUEST}list';
  static const String STATUS_REQUEST_CHARGER = '${REQUEST}update-status';
  static const String START_CHARGING = '${CHARGER}start-charging';
  static const String PAYMENT_CHARGER = '${REQUEST}charge-payment';
  static const String FETCH_NOTIFICATION_LIST = '${NOTIFICATIONS}list';
  static const String FETCH_NOTIFICATION_COUNT = '${NOTIFICATIONS}count';
  static const String DELETE_NOTIFICATIONS = '${NOTIFICATIONS}delete/';
  static const String ADD_CAR = '${CAR}add';
  static const String FETCH_CAR_LIST = '${CAR}list';
  static const String UPDATE_CAR = '${CAR}update/';
  static const String DELETE_CAR = '${CAR}delete/';
  static const String UPDATE_TOKEN = '${CAR}update-refresh-token';
  static const String INVOICE_LIST = '${INVOICEHISTORY}list';
  static const String HEADER = 'application/x-www-form-urlencoded;charset=utf-8';
  static const String STRIPE = 'https://api.stripe.com/v1/tokens';
  static const String CODE_EXCHANGE = 'oauth/token';
  static const String ALL_Vehicle = 'v2.0/vehicles/';
  static const String READ_BATTERY = '/battery';
  static const String START_CHARGING_API = '/Start_charge';
  static const String REAL_DATA = '/realdata';
  static const String STOP_CHARGING_API = '/Stop_charge';


  // Shared Key

  static const String THEME = 'GlowSolarTheme';
  static const String LOGIN_USER = 'LoginUser';
  static const String FCM_TOKEN = 'FcmToken';
  static const String DEFAULT_SOLAR_ID = 'defaultSolarId';
  static const String DEFAULT_CAR_ID = 'CarId';
  static const String LOCATION = 'Location';
  static const String COUNTRY_CODE = 'GlowSolarCountryCode';
  static const String LANGUAGE_CODE = 'GlowSolarLanguageCode';
  static const String USER_PASSWORD = 'GlowSolarUserPassword';
  static const String USER_ADDRESS = 'GlowSolarUserAddress';
  static const String USER_NUMBER = 'GlowSolarUserNumber';
  static const String USER_COUNTRY_CODE = 'GlowSolarUserCountryCode';
  static const String NOTIFICATION = 'GlowSolarNotification';
  static const String SEARCH_HISTORY = 'GlowSolarSearchHistory';
  static const String INTRO = 'GlowSolarIntro';
  static const String NOTIFICATION_COUNT = 'GlowSolarNotificationCount';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'
    ),
  ];

  static List<String> unitData = [
    "Kwh",
    "Wh",
  ];

  static List<String> chargerPricingVariable = [
    "Minutes",
    "Kwh",
  ];

}

const List<TimeLine> solarGraphTimeList= <TimeLine>[
  TimeLine.Day,
  TimeLine.Week,
  TimeLine.Month,
  TimeLine.Year,
];
