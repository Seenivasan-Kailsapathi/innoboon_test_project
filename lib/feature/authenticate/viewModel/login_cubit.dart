import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view/webview_screen.dart';

abstract class LoginScreenState {}

class LoginInitial extends LoginScreenState {}

class LoginCubit extends Cubit<LoginScreenState> {
  LoginCubit():super(LoginInitial());

  signInButtonClicked(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WebViewScreen()));
  }


}