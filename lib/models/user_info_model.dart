class UserInfoModel {
  final String? uid;
  final String? username;
  final String? email;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? userType;
  final String? languagePreference;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final bool profileCompleted;
  final dynamic createdAt;

  UserInfoModel({
    this.uid,
    this.username,
    this.email,
    this.avatarUrl,
    this.phoneNumber,
    this.userType,
    this.languagePreference,
    this.firstName,
    this.lastName,
    this.gender,
    this.profileCompleted = false,
    this.createdAt,
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
      firstName: data['firstName'],
      lastName: data['lastName'],
      gender: data['gender'],
      profileCompleted: data['profileCompleted'] ?? false,
      createdAt: data['createdAt'],
    );
  }
}
