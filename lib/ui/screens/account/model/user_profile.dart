class UserProfile {
  const UserProfile({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.idCard,
    required this.gender,
    required this.address,
    required this.roleName,
    required this.photo,
    required this.position,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String? _string(dynamic value) => value?.toString();

    return UserProfile(
      userId: _string(json['USERID']) ?? '',
      userName: _string(json['USERNAME']) ?? '',
      fullName: _string(json['NAMA']) ?? '',
      email: _string(json['EMAIL']) ?? '',
      phone: _string(json['NOHP']) ?? '',
      idCard: _string(json['IDCARD']) ?? '',
      gender: _string(json['GENDER']) ?? '',
      address: _string(json['ADDRESS']) ?? '',
      roleName: _string(json['ROLENM']) ?? '',
      photo: _string(json['PHOTO']) ?? '',
      position: _string(json['POSITION']) ?? '',
    );
  }

  final String userId;
  final String userName;
  final String fullName;
  final String email;
  final String phone;
  final String idCard;
  final String gender;
  final String address;
  final String roleName;
  final String photo;
  final String position;
}

class UserProfileResponse {
  const UserProfileResponse({
    required this.user,
    required this.errorCode,
    required this.errorMessage,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final user =
        userJson is Map<String, dynamic> ? UserProfile.fromJson(userJson) : null;

    int? _parseErr(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return UserProfileResponse(
      user: user,
      errorCode: _parseErr(json['err_code'] ?? json['errCode']) ?? 0,
      errorMessage: (json['err_msg'] ?? json['errMsg'])?.toString() ?? '',
    );
  }

  final UserProfile? user;
  final int errorCode;
  final String errorMessage;
}
