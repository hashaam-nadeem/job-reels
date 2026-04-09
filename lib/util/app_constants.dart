import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jobreels/enums/validation_type.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/skill_constant.dart';
import '../data/model/response/language_model.dart';

DefaultCacheManager cacheManager = DefaultCacheManager();

class AppConstants {
  static const String APP_NAME = 'JobReels';
  static const double APP_VERSION = 1.0;
  static const int PASSWORD_MIN_LENGTH = 6;
  static const int TEXT_FIELD_MAX_LENGTH = 250;
  static const int DIGIT_TEXT_FIELD_MAX_LENGTH = 4;
  static const double padding =20;
  static const double avatarRadius =35;
  static const double cameraAspectRatio = 10/18.3;

  /// Api section

  static const String baseUrl = 'https://www.jobreels.app';
  static const String api = '/api';
  static const String getPostList = '$api/posts/list/guest';
  static const String getSearchedPostList = '$api/post/search';
  static const String user = '$api/user/';
  static const String auth = user;
  static String getUserProfile = user;
  static String getOtherUserProfile = "${user}profile/";
  static const String login = '${auth}login';
  static const String reportPostFlags = '$api/flags';
  static const String reportUserFlags = '$api/user-flags';
  static const String logout = '${auth}logout';
  static const String uploadPost = '$api/v1/post/create';
  static const String updatePost = '$api/post/update/';
  static const String deletePost = '$api/posts/';
  static const String reportPost = '$api/post/flag';
  static const String reportUser = '${user}flag';
  static const String bookmarkPost = '$api/post/save/';
  static const String getStates = '$api/states/list?country=';
  static const String validatePhoneNumberOrEmail = '${user}data-validation';
  static const String sendFreelancerOtp = '${user}registerFreelancerOtp';
  static const String sendForgotPasswordOtp = '$api/forget-otp';
  static const String resetPassword = '$api/forget-password';
  static const String registerHirerOtp = '${user}registerHirerOtp';
  static const String registerFreelancer = '${user}registerFreelancer';
  static const String registerHirer = '${user}registerHirer';
  static const String updateFreelancer = '${user}updateFreelancer';
  static const String updateHirer = '${user}updateHirer';
  static const String fetchNotificationList = '${user}notifications';
  static const String updateFreelancerProfileImage = '${user}updateFreelancerProfileImage';
  static const String sendDeleteAccountOtp = '${user}deleteAccountOtp';
  static const String deleteAccount = '${user}deleteAccount';
  static const String thread = '$api/thread/';
  static const String fetchThreadId = '${thread}add';
  static const String fetchThreadList = '${thread}list';
  static const String fetchThreadMessages = '$api/message?thread_id=';

  static const String PASSWORD = '/api/password/';
  static const String REQUEST = '/api/charging-request/';
  static const String NOTIFICATIONS = '/api/notification/';
  static const String INVOICEHISTORY = '/api/payment-history/';

  static const String UPDATE_FCM_TOKEN = '${auth}add-fcm-token';

  static const String FORGET = '${PASSWORD}forgot';
  static const String RESET = '${PASSWORD}reset';
  static const String CHANGE_PASSWORD = '${PASSWORD}change';
  static const String OTP_VERIFy = '/api/otp-code/verify';
  static const String REGISTER_OTP_VERIFY = '${auth}verify';
  static const String FETCH_SOLAR_PRODUCTION = 'site/';
  static const String FETCH_CHARGER_Api = 'https://fr.wydq.tech/weeyuen/api.php/interface';
  static const String FETCH_CHARGER_WITH_PILENO = '/realdata';
  static const String ADD_REQUEST_CHARGER = '${REQUEST}add';
  static const String FETCH_REQUEST_CHARGER = '${REQUEST}list';
  static const String STATUS_REQUEST_CHARGER = '${REQUEST}update-status';
  static const String PAYMENT_CHARGER = '${REQUEST}charge-payment';
  static const String FETCH_NOTIFICATION_COUNT = '${NOTIFICATIONS}count';
  static const String DELETE_NOTIFICATIONS = '${NOTIFICATIONS}delete/';
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
  static const String SUBSCRIBED_USERS = 'SubscribedUsers';
  static const String AUTH_TOKEN_USER = 'LoginUserAuthToken';
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

class Skill {
  final String value;
  final String label;
  final String fullLabel;
  final String category;

  Skill({
    required this.value,
    required this.label,
    required this.fullLabel,
    required this.category,
  });
}

List<String> availabilityFilterList = ["Any", "Full time", "Part time"];
List<String> yearsOfExperienceList = [
  "Less than 1 year",
  "1-2 years",
  // "2 years",
  "3+ years",
  // "4 years",
  // "5 years",
  // "More than 5 years",
];

List<Skill>skillList = skillsMapList.map((skill) {
    return Skill(
      value: setCapitalizationOfString(skill['value']!),
      label: setCapitalizationOfString(skill['label']!),
      fullLabel: setCapitalizationOfString(skill['fullLabel']!),
      category: setCapitalizationOfString(skill['category']!),
    );
  }).toList();

String setCapitalizationOfString(String input){
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}


List<String> howMuchExperienceDropDownList = <String>[
  "Any",
  "Less than 1 year",
  "1-2 years",
  "3+ years",
];
List<String> hirerIndustryList = <String>[
  "Real Estate",
  "Healthcare",
  "Legal",
  "Online Retailer",
  "Financial",
  "Coach",
  "Sales / Marketing",
  "Other",
];

