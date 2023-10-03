// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserToken _$UserTokenFromJson(Map<String, dynamic> json) {
  return UserToken(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String?,
  );
}

Map<String, dynamic> _$UserTokenToJson(UserToken instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

UserProfileDetail _$UserProfileDetailFromJson(Map<String, dynamic> json) {
  return UserProfileDetail(
    userName: json['userName'] as String,
    userProfilePicture: json['userProfilePicture'] as String,
    userGender: json['userGender'] as String,
  );
}

Map<String, dynamic> _$UserProfileDetailToJson(UserProfileDetail instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userProfilePicture': instance.userProfilePicture,
      'userGender': instance.userGender,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    userId: json['id'] as String,
    userEmail: json['email'] as String,
    userProfileDetails: UserProfileDetail(
        userName: json['full_name'],
        userProfilePicture: json['photo'],
        userGender: json['gender']),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'userProfileDetails': instance.userProfileDetails,
      'userTokens': instance.userTokens,
    };
