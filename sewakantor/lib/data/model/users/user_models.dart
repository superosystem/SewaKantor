import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

@JsonSerializable()
class UserToken {
  late String accessToken;
  late String? refreshToken;
  UserToken({required this.accessToken, required this.refreshToken});

  factory UserToken.fromJson(Map<String, dynamic> json) =>
      _$UserTokenFromJson(json);
  Map<String, dynamic> toJson() => _$UserTokenToJson(this);
}

@JsonSerializable()
class UserProfileDetail {
  late String userName;
  late String userProfilePicture;
  late String userGender;
  UserProfileDetail(
      {required this.userName,
      required this.userProfilePicture,
      required this.userGender});

  factory UserProfileDetail.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDetailFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileDetailToJson(this);
}

@JsonSerializable()
class UserModel {
  late String userId;
  late String userEmail;
  late UserProfileDetail userProfileDetails;
  UserToken? userTokens;

  UserModel(
      {required this.userId,
      required this.userEmail,
      required this.userProfileDetails,
      this.userTokens});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
