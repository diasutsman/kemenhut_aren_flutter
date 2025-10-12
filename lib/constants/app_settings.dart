// lib/constants/settings.dart
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  // ==================== SETTINGS ====================
  static const int DELAY_SPLASH_TIME = 3500;
  static const String ABOUT_URL = "https://kehutanan.go.id";
  static const String TERMS_URL = "http://interludeindonesia.com/terms";
  static const String SKETSA_URL =
      "https://wip.pnpgroups.com/globals/spkimg?id=";
  static const String CHART_URL =
      "https://wip.pnpgroups.com/globals/performance";
  static String PHONE_NUMBER = "+622122227035";
  static const int UPLOAD_FILE_MB_LIMIT = 2;
  static const int UPLOAD_PHOTO_KB_LIMIT = 500;
  static const int MAX_TIME_OUT = 1800;
  static const int INTERVAL_CHANGES = 1200;
  static const int INTERVAL_CHANGES1 = 1800;
  static const int INTERVAL_CHANGES2 = 10800;
  static const int ANIMATE_TIME = 1500;
  static const double SELECTED_ALPHA = 1.0;
  static const double UNSELECTED_ALPHA = 0.62;
  static double COMMISION_RATE = 0.03;
  static double COMMISION_PERCENT = 3.00;

  // ==================== URLS ====================
  static String URL_BASE = "http://103.82.242.130/kemenhut_aren/";
  static String URL_LOGIN = "${URL_BASE}login/confirm";
  static String URL_FORGOT_CHECK = "${URL_BASE}login/forgot";
  static String URL_FORGOT_CONFIRM = "${URL_BASE}login/confirm_forgot";
  static String URL_ASSGN_INIT = "${URL_BASE}response/assgn";
  static String URL_RESPONSE_LIST = "${URL_BASE}response/list";
  static String URL_VIEW_PLAN = "${URL_BASE}response/plan";
  static String URL_VIEW_PLAN2 = "${URL_BASE}response/plan2";
  static String URL_VIEW_AREN = "${URL_BASE}aren/view";
  static String URL_VIEW_SPK = "${URL_BASE}response/spkno";
  static String URL_DETAIL_SPK = "${URL_BASE}response/viewspk";
  static String URL_KARYAWAN_LIST = "${URL_BASE}user/karyawan";
  static String URL_DETAIL_SPECIAL = "${URL_BASE}response/viewspecial";
  static String URL_REPORT_MAIN = "${URL_BASE}response/main";
  static String URL_REPORT_MAIN2 = "${URL_BASE}response/main2";
  static String URL_GET_SISA = "${URL_BASE}response/sisa";
  static String URL_GET_SISA2 = "${URL_BASE}response/sisa2";
  static String URL_SAVE_TIMER = "${URL_BASE}response/start";
  static String URL_GET_TIMER = "${URL_BASE}response/timer";
  static String URL_GET_TIMER2 = "${URL_BASE}response/timer2";

  // ==================== LOG / VERSION ====================
  static const String ERROR_TAG = "ERROR";
  static const String DEBUG_TAG = "DEBUG";
  static const String VERSION_CODE = "1.0.31";

  // ==================== SUCCESS / VALIDATION ====================
  static const int SUCCESS_CODE = 200;
  static const int VALIDATION_ERROR = 400;

  // ==================== SESSION TAGS ====================
  static const String ACCOUNT_PREF = "ACC_PREF";

  // ==================== STATUS CONSTANTS ====================
  static const int STS_ACTIVE = 1;
  static const int STS_NON_ACTIVE = 0;
  static const int STS_REJECTED = 2;
  static const String STS_ALL = "%";
  static const String STS_ACTIVE_S = "1";
  static const String STS_NON_ACTIVE_S = "0";
  static const String STS_REJECTED_S = "2";
  static const int STS_YES = 1;
  static const int STS_NO = 0;

  static const String STS_ACTIVE_TEXT = "Active";
  static const String STS_NON_ACTIVE_TEXT = "Not Active";
  static const String STS_FINISH_TEXT = "Finish";
  static const String STS_NON_FINISH_TEXT = "Not Finish";
  static const String STS_ON_PROGRESS_TEXT = "On Progress";
  static const String STS_PENDING_TEXT = "Pending";
  static const String STS_RETENTION_TEXT = "In Retention";
  static const String STS_AGREEMENT_TEXT = "In Agreement";
  static const String STS_CANCELED_TEXT = "Canceled";

  static const String STS_NEW = "N";
  static const String STS_PDG = "P";
  static const String STS_APV = "A";
  static const String STS_CAN = "C";
  static const String STS_RJC = "R";

  static const String STS_SDH = "Sudah";
  static const String STS_BLM = "Belum";

  // ==================== ROLE / TYPES ====================
  static const String ROLE_EPSON = "Epson";
  static const String ROLE_DISTRIBUTOR = "Distributor";
  static const String ROLE_DEALER = "Dealer";
  static const String ROLE_RESELLER = "Reseller";

  static const String TYPE_PROJECT = "PRJCT";
  static const String TYPE_TASK = "TSK";
  static const String TYPE_PHASE = "PHS";
  static const String TYPE_PROPERTY = "PROP";
  static const String TYPE_VENDOR = "VNDR";
  static const String TYPE_PROPOSE = "PRPS";
  static const String TYPE_EXPENSE = "EXPS";
  static const String TYPE_INVOICE = "INVC";
  static const String TYPE_NOTIF = "NTF";
  static const String TYPE_CONTRACT = "CNTRCT";
  static const String TYPE_MATERIAL = "MTRL";
  static const String TYPE_TASK_COM = "TCMT";
  static const String TYPE_PROJECT_COM = "PCMT";
  static const String TYPE_PROPOSE_COM = "RCMT";
  static const String TYPE_PROPERTY_COM = "OCMT";
  static const String TYPE_PROJECT_IMG = "PIMG";
  static const String TYPE_PROPERTY_IMG = "RIMG";
  static const String TYPE_PHASE_IMG = "PHIMG";
  static const String TYPE_TASK_IMG = "TIMG";
  static const String TYPE_CORPORATE = "C";
  static const String TYPE_PERSONAL = "P";

  // ==================== TEXT CONSTANTS ====================
  static const String NOT_PAID_TEXT = "Not Paid";
  static const String PAID_TEXT = "Paid";
  static const String NEED_APPROVE_TEXT = "In Approval";
  static const String REJECT_TEXT = "Rejected";
  static const String NEED_REVISED_TEXT = "Proposal Need Revision";
  static const String ACCEPTED_TEXT = "Accepted";
  static const String ON_REQUEST_TEXT = "On Request";
  static const String BELUM_TTD_TEXT = "Belum Dittd";
  static const String IN_PROGRESS = "Dalam Proses";
  static const String ACTIVE_TEXT = "Sudah aktif";
  static const String CONF_REJECTED = "Konfirmasi ditolak";
  static const String REJECTED = "Kontrak ditolak";

  // ==================== SUPPLY ====================
  static const String SUPPLY_INTERLUDE = "I";
  static const String SUPPLY_MYSELF = "M";

  // ==================== FIREBASE / BROADCAST TAGS ====================
  static const String TOPIC_GLOBAL = "global";
  static const String REGISTRATION_COMPLETE = "registrationComplete";
  static const String PUSH_NOTIFICATION = "pushNotification";
  static const String RESTART_SERVICE = "restartService";
  static const int NOTIFICATION_ID = 100;
  static const int NOTIFICATION_ID_BIG_IMAGE = 101;
  static const String SHARED_PREF = "myFirebase";
  static const String FIREBASE_ID = "regId";

  static const String ANDROID_MAIN = "android.intent.action.MAIN";
  static const String DETAIL_DATA = "android.intent.action.DETAIL_DATA";
  static const String TASK_DATA = "android.intent.action.TASK_DATA";
  static const String PHASE_DATA = "android.intent.action.PHASE_DATA";
  static const String SOUT_DEAD = "android.intent.action.SOUT_DEAD";
  static const String SOUT_BROKEN = "android.intent.action.SOUT_BROKEN";
  static const String PROPOSE_DATA = "android.intent.action.PROPOSE";
  static const String INTENT_INTERNET_CHANGE =
      "android.net.conn.CONNECTIVITY_CHANGE";

  // ==================== SESSION VARIABLES ====================
  static String userID = "";
  static String adminID = "";
  static String partnerCode = "SYNGDG";
  static String partnerName = "";
  static String empID = "";
  static String partnerLevel = "";
  static String partnerPosition = "";

  // ==================== SESSION MANAGEMENT ====================
  static Future<void> createSession(
    String userID,
    String empID,
    String partnerLevel,
    String partnerPosition,
    String partnerID,
    String partnerCode,
    String partnerName,
    String username,
    String firstName,
    String photo,
    String email,
    String session,
    String fbAcc,
    String googleAcc,
    String adminID,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fb", fbAcc.isNotEmpty);
    await prefs.setBool("google", googleAcc.isNotEmpty);

    await prefs.setString("userID", userID);
    await prefs.setString("adminID", adminID);
    await prefs.setString("partnerID", partnerID);
    await prefs.setString("partnerCode", partnerCode);
    await prefs.setString("partnerName", partnerName);
    await prefs.setString("level", partnerLevel);
    await prefs.setString("position", partnerPosition);
    await prefs.setString("username", username);
    await prefs.setString("first_name", firstName);
    await prefs.setString("email", email);
    await prefs.setString("photo", photo);
    await prefs.setString("fbAcc", fbAcc);
    await prefs.setString("googleAcc", googleAcc);
    await prefs.setString("sessionID", session);

    AppSettings.userID = userID;
    AppSettings.empID = empID;
    AppSettings.adminID = adminID;
  }

  static Future<Account> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final account = Account(
      userID: prefs.getString("userID") ?? "",
      adminID: prefs.getString("adminID") ?? "",
      partnerID: prefs.getString("partnerID") ?? "",
      partnerLevel: prefs.getString("level") ?? "",
      partnerPosition: prefs.getString("position") ?? "",
      partnerCode: prefs.getString("partnerCode") ?? "",
      partnerName: prefs.getString("partnerName") ?? "",
      username: prefs.getString("username") ?? "",
      firstName: prefs.getString("first_name") ?? "",
      email: prefs.getString("email") ?? "",
      photo: prefs.getString("photo") ?? "",
      sessionID: prefs.getString("sessionID") ?? "",
    );

    print('getSession() account: $account');

    AppSettings.userID = account.userID;
    AppSettings.adminID = account.adminID;
    return account;
  }

  static Future<bool> checkValidSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("userID");
  }

  static Future<void> destroySession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    AppSettings.userID = "";
  }

  static Future<void> destroyFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(FIREBASE_ID);
  }
}

// ==================== ACCOUNT MODEL ====================
class Account {
  final String userID;
  final String adminID;
  final String partnerID;
  final String partnerLevel;
  final String partnerPosition;
  final String partnerCode;
  final String partnerName;
  final String username;
  final String firstName;
  final String email;
  final String photo;
  final String sessionID;

  @override
  String toString() {
    return 'Account(userID=$userID, adminID=$adminID, partnerID=$partnerID, partnerLevel=$partnerLevel, partnerPosition=$partnerPosition, partnerCode=$partnerCode, partnerName=$partnerName, username=$username, firstName=$firstName, email=$email, photo=$photo, sessionID=$sessionID)';
  }

  Account({
    required this.userID,
    required this.adminID,
    required this.partnerID,
    required this.partnerLevel,
    required this.partnerPosition,
    required this.partnerCode,
    required this.partnerName,
    required this.username,
    required this.firstName,
    required this.email,
    required this.photo,
    required this.sessionID,
  });
}
