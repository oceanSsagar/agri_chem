class UserInfoModel {
  final String? uid;
  final String? username;
  final String? email;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? userType;
  final String? languagePreference;

  UserInfoModel({
    this.uid,
    this.username,
    this.email,
    this.avatarUrl,
    this.phoneNumber,
    this.userType,
    this.languagePreference,
  });

  factory UserInfoModel.fromMap(Map<String, dynamic> data) {
    return UserInfoModel(
      uid: data['uid'],
      username: data['username'],
      email: data['email'],
      avatarUrl: data['avatarUrl'],
      phoneNumber: data['phoneNumber'],
      userType: data['userType'],
      languagePreference: data['languagePreference'],
    );
  }
}
