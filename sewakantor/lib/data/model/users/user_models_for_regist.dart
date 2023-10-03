import 'package:json_annotation/json_annotation.dart';

part 'user_models_for_regist.g.dart';

@JsonSerializable()
class UserModelForRegist {
  late String full_name;
  late String gender;
  late String email;
  late String password;
  late String confirmation_password;
  String? photo;
  UserModelForRegist(
      {required this.full_name,
      required this.gender,
      required this.email,
      required this.password,
      required this.confirmation_password,
      this.photo});
  factory UserModelForRegist.fromJson(Map<String, dynamic> json) =>
      _$UserModelForRegistFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelForRegistToJson(this);
}
