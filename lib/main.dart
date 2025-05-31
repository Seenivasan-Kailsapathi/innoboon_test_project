import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inno_boon_interview/core/storage/storage_service.dart';
import 'package:inno_boon_interview/feature/authenticate/viewModel/login_cubit.dart';
import 'package:inno_boon_interview/feature/home/viewModel/home_screen_cubit.dart';
import 'package:inno_boon_interview/feature/details/viewModel/repository_detail_screen_cubit.dart';
import 'package:inno_boon_interview/feature/authenticate/viewModel/webview_cubit.dart';
import 'package:inno_boon_interview/feature/splash/splash_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await StorageService.instance.initializeSharedPreference();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<WebViewScreenCubit>(create: (_) => WebViewScreenCubit()),
        BlocProvider<HomeScreenCubit>(create: (_) => HomeScreenCubit()),
        BlocProvider<DetailScreenCubit>(create: (_) => DetailScreenCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),

        home: const SplashScreen(),
      ),
    );
  }
}