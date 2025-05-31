import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inno_boon_interview/core/network/api_service.dart';
import 'package:inno_boon_interview/core/storage/storage_service.dart';
import 'package:inno_boon_interview/feature/authenticate/viewModel/web_view_states.dart';
import 'package:inno_boon_interview/feature/home/view/home_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;


class WebViewScreenCubit extends Cubit<WebViewScreenState> {
  WebViewScreenCubit() : super(WebViewScreenInitial());

  late WebViewController controller;
  late final NavigationDelegate navigationDelegate;


  final String clientId =dotenv.env['GITHUB_CLIENT_ID'] ?? '';
  final String clientSecret = dotenv.env['GITHUB_CLIENT_SECRET'] ?? '';
  final String redirectUri = dotenv.env['GITHUB_REDIRECT_URL'] ?? '';
// final cookieManager = WebviewCookieManager();


  void initWebView(BuildContext context) {
    emit(WebViewScreenLoading());

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(_buildNavigationDelegate(context))
      ..loadRequest(Uri.parse(_buildGitHubAuthUrl()));
  }

  NavigationDelegate _buildNavigationDelegate(BuildContext context) {
    return NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith(redirectUri)) {
          handleAuthResponse(request.url, context);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageStarted: (_) => emit(WebViewScreenLoading()),
      onPageFinished: (_) => emit(WebViewScreenLoaded()),
      onProgress: (_) {},
      onWebResourceError: (_) => emit(WebViewScreenError()),
    );
  }

  String _buildGitHubAuthUrl() {
    return 'https://github.com/login/oauth/authorize'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&scope=read:user,user:email,repo,read:org';
  }

  Future<void> handleAuthResponse(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    final String? code = uri.queryParameters['code'];

    if (code != null) {
      final token = await getAccessToken(code);
      if (token != null) {
        if (context.mounted) {
          await signInWithFirebase(token, context);
        }
      } else {
        _showErrorSnackbar(context);
      }
    } else {
      _showErrorSnackbar(context);
    }
  }

  Future<String?> getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse('https://github.com/login/oauth/access_token'),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    }
    return null;
  }

  Future<void> clearCache() async {

    // Clear cookies and cache
    await controller.clearCache();
    await controller.clearLocalStorage();
    //await CookieManager().clearCookies();
    await controller.reload();
  }

  Future<void> signInWithFirebase(String token, BuildContext context) async {
    final AuthCredential credential = GithubAuthProvider.credential(token);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    ApiService.instance.token = userCredential.credential?.accessToken;

    if ((userCredential.credential?.accessToken?.isNotEmpty ?? false)) {
      final signInUserInfo = await ApiService.instance.fetchGitHubUserDetailsFromApi();

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(signInUserInfo: signInUserInfo)),
        );
        StorageService.instance.setGitHubUserName("userName", signInUserInfo?.login ?? "");
        StorageService.instance.setTokenValue("token", userCredential.credential?.accessToken ?? "");
      }
    } else {
      _showErrorSnackbar(context);
    }
  }

  void _showErrorSnackbar(BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token not fetched. Try again")),
      );
    }
  }


}
