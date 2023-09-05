import 'package:dio/dio.dart';

import '../../../../../core/params/base_params.dart';

class LoginRequest extends BaseParams {
  LoginRequest(
      {this.userNameOrEmailAddress,
      this.password,
      this.rememberClient,
      CancelToken? cancelToken})
      : super(cancelToken: cancelToken);

  final String? userNameOrEmailAddress;
  final String? password;
  final bool? rememberClient;

  factory LoginRequest.fromMap(Map<String, dynamic> json) => LoginRequest(
        userNameOrEmailAddress: json["userNameOrEmailAddress"],
        password: json["password"],
        rememberClient:
            json["rememberClient"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "userNameOrEmailAddress":
            userNameOrEmailAddress,
        "password": password,
        "rememberClient": rememberClient,
      };
}
