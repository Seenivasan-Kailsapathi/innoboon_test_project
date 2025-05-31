import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_boon_interview/core/constants/app_colors.dart';
import 'package:inno_boon_interview/core/constants/app_images.dart';
import 'package:inno_boon_interview/core/constants/app_strings.dart';
import 'package:inno_boon_interview/core/constants/app_text_styles.dart';
import 'package:inno_boon_interview/feature/authenticate/view/webview_screen.dart';
import 'package:inno_boon_interview/feature/authenticate/viewModel/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  late LoginCubit loginCubit;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    loginCubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),

                Center(
                  child: Image.asset(
                    AppImages().appLogo,
                    height: 70,
                    width: 180,
                  ),
                ),

                const SizedBox(height: 24),

                Image.asset(
                  AppImages().loginScreenImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 32),

                Text(
                  AppStrings().loginScreenMsgTitle,
                  style: AppTextStyles().loginTitleTextStyle ,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  AppStrings().loginScreenMessage,
                  style:  AppTextStyles().loginMessageTextStyle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MaterialButton(
                    color: AppColors().buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () => loginCubit.signInButtonClicked(context),
                    child:  Text(
                      "Sign in with GitHub",
                      style: AppTextStyles().loginButtonTextStyle,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

