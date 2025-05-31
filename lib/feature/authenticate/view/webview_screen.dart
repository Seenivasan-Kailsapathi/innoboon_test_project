import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_boon_interview/feature/authenticate/viewModel/webview_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';


import '../viewModel/web_view_states.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewScreenCubit webViewScreenCubit;

  @override
  void initState() {
    super.initState();

    webViewScreenCubit = BlocProvider.of<WebViewScreenCubit>(context);

    webViewScreenCubit.initWebView(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Login", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: BlocBuilder<WebViewScreenCubit, WebViewScreenState>(
          builder: (context, state) {
            if (state is WebViewScreenError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    const Text("Failed to load page. Please try again."),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        webViewScreenCubit.initWebView(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                WebViewWidget(controller: webViewScreenCubit.controller),
                if (state is WebViewScreenLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
