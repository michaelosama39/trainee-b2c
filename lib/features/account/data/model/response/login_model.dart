



import '../../../../../core/models/base_model.dart';
import '../../../domain/entity/login_entity.dart';

class LoginModel extends BaseModel<LoginEntity>{
  LoginModel({
    this.accessToken,
    this.encryptedAccessToken,
    this.expireInSeconds,
    this.userId,
    this.restaurantId,
    this.shopId,
  });

  final String? accessToken;
  final String? encryptedAccessToken;
  final int? expireInSeconds;
  final int? userId;
  final int? restaurantId;
  final int? shopId;

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
    accessToken: json["accessToken"],
    encryptedAccessToken: json["encryptedAccessToken"],
    expireInSeconds: json["expireInSeconds"],
    userId: json["userId"],
    restaurantId: json["restaurantId"],
    shopId: json["shopId"],
  );

  Map<String, dynamic> toMap() => {
    "accessToken": accessToken,
    "encryptedAccessToken": encryptedAccessToken,
    "expireInSeconds": expireInSeconds,
    "userId": userId,
    "restaurantId": restaurantId,
    "shopId": shopId,
  };

  @override
  LoginEntity toEntity() {
    return LoginEntity(
      accessToken: accessToken,
      encryptedAccessToken: encryptedAccessToken,
      expireInSeconds: expireInSeconds,
      restaurantId: restaurantId,
      shopId: shopId,
      userId: userId,
    );
  }
}
