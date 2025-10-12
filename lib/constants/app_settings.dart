// lib/constants/settings.dart
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  // ====== AppSettings (ported 1:1 from Java) ======
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

  // ====== URL WS ======
  static String URL_BASE = "http://103.82.242.130/kemenhut_aren/";
  static String URL_LOGIN = "${URL_BASE}login/confirm";
  static String URL_ASSGN_INIT =
      "$URL_BASE"
      "response/assgn";
  static String URL_RESPONSE_LIST =
      "$URL_BASE"
      "response/list";
  static String URL_VIEW_PLAN =
      "$URL_BASE"
      "response/plan";
  static String URL_VIEW_PLAN2 =
      "$URL_BASE"
      "response/plan2";
  static String URL_VIEW_AREN =
      "$URL_BASE"
      "aren/view";
  static String URL_VIEW_SPK =
      "$URL_BASE"
      "response/spkno";
  static String URL_DETAIL_SPK =
      "$URL_BASE"
      "response/viewspk";
  static String URL_KARYAWAN_LIST =
      "$URL_BASE"
      "user/karyawan";
  static String URL_DETAIL_SPECIAL =
      "$URL_BASE"
      "response/viewspecial";
  static String URL_REPORT_MAIN =
      "$URL_BASE"
      "response/main";
  static String URL_REPORT_MAIN2 =
      "$URL_BASE"
      "response/main2";
  static String URL_GET_SISA =
      "$URL_BASE"
      "response/sisa";
  static String URL_GET_SISA2 =
      "$URL_BASE"
      "response/sisa2";
  static String URL_SAVE_TIMER =
      "$URL_BASE"
      "response/start";
  static String URL_GET_TIMER =
      "$URL_BASE"
      "response/timer";
  static String URL_GET_TIMER2 =
      "$URL_BASE"
      "response/timer2";

  // ====== Misc App / Log ======
  static const String ERROR_TAG = "ERROR";
  static const String DEBUG_TAG = "DEBUG";
  static const String VERSION_CODE = "1.0.31";

  // ====== Success / Validation ======
  static const int SUCCESS_CODE = 200;
  static const int VALIDATION_ERROR = 400;

  // ====== Session Tags ======
  static const String ACCOUNT_PREF = "ACC_PREF";

  // ====== Session Variables (in-memory mirrors) ======
  static String userID = "";
  static String adminID = "";

  // ====== Account model (simple) ======
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
    final dPref = await SharedPreferences.getInstance();
    await dPref.setBool("fb", fbAcc.isNotEmpty);
    await dPref.setBool("google", googleAcc.isNotEmpty);

    final sPref = await SharedPreferences.getInstance();
    await sPref.setString("userID", userID);
    await sPref.setString("adminID", adminID);
    await sPref.setString("partnerID", partnerID);
    await sPref.setString("partnerCode", partnerCode);
    await sPref.setString("partnerName", partnerName);
    await sPref.setString("level", partnerLevel);
    await sPref.setString("position", partnerPosition);
    await sPref.setString("username", username);
    await sPref.setString("first_name", firstName);
    await sPref.setString("email", email);
    await sPref.setString("photo", photo);
    await sPref.setString("fbAcc", fbAcc);
    await sPref.setString("googleAcc", googleAcc);
    await sPref.setString("sessionID", session);

    AppSettings.userID = userID;
    AppSettings.adminID = adminID;
  }

  static Future<Account> getSession() async {
    final sPref = await SharedPreferences.getInstance();
    final acc = Account(
      userID: sPref.getString("userID") ?? "",
      adminID: sPref.getString("adminID") ?? "",
      partnerID: sPref.getString("partnerID") ?? "",
      partnerLevel: sPref.getString("level") ?? "",
      partnerPosition: sPref.getString("position") ?? "",
      partnerCode: sPref.getString("partnerCode") ?? "",
      partnerName: sPref.getString("partnerName") ?? "",
      username: sPref.getString("username") ?? "",
      firstName: sPref.getString("first_name") ?? "",
      email: sPref.getString("email") ?? "",
      photo: sPref.getString("photo") ?? "",
      sessionID: sPref.getString("sessionID") ?? "",
    );

    AppSettings.userID = acc.userID;
    AppSettings.adminID = acc.adminID;
    return acc;
  }

  static Future<bool> checkValidSession() async {
    final sPref = await SharedPreferences.getInstance();
    return sPref.containsKey("userID");
  }

  static Future<void> destroySession() async {
    final sPref = await SharedPreferences.getInstance();
    await sPref.clear();
    AppSettings.userID = "";
  }
}

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
