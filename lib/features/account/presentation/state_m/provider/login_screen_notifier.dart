import 'package:flutter/material.dart';

import '../../../../../core/common/costum_modules/screen_notifier.dart';
import '../../../../../core/constants/app/app_constants.dart';
import '../bloc/account_cubit.dart';

class LoginScreenNotifier extends ScreenNotifier {
  /// Fields
  late BuildContext context;
  final AccountCubit _accountCubit = AccountCubit();
  bool isLoading = false;
  bool passwordSecure = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String countryCode = AppConstants.DEFAULT_COUNTRY_CODE;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Getters and Setters
  AccountCubit get accountCubit => _accountCubit;

  TextEditingController get phoneController => _phoneController;

  void setPhoneNumber(String number) {
    phoneController.text = number;
    notifyListeners();
  }

  TextEditingController get passwordController => _passwordController;

  FocusNode get phoneFocusNode => _phoneFocusNode;

  FocusNode get passwordFocusNode => _passwordFocusNode;

  GlobalKey<FormState> get formKey => _formKey;

  /// Methods

  @override
  void closeNotifier() {
    accountCubit.close();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    phoneController.dispose();
    passwordController.dispose();
    dispose();
  }
}
