// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models_for_regist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelForRegist _$UserModelForRegistFromJson(Map<String, dynamic> json) {
  return UserModelForRegist(
      full_name: json['full_name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      confirmation_password: json['confirmation_password'] as String);
}

Map<String, dynamic> _$UserModelForRegistToJson(UserModelForRegist instance) =>
    <String, dynamic>{
      'full_name': instance.full_name,
      'gender': instance.gender,
      'email': instance.email,
      'password': instance.password,
      'confirmation_password': instance.confirmation_password,
    };
