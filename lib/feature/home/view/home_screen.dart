import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_boon_interview/core/constants/app_strings.dart';
import 'package:inno_boon_interview/core/constants/app_text_styles.dart';
import 'package:inno_boon_interview/core/network/api_service.dart';
import 'package:inno_boon_interview/core/storage/storage_service.dart';
import 'package:inno_boon_interview/feature/details/view/repository_details_page.dart';
import 'package:inno_boon_interview/feature/home/viewModel/home_screen_cubit.dart';
import 'package:inno_boon_interview/feature/home/viewModel/home_screen_state.dart';
import 'package:inno_boon_interview/model/github_projects_model.dart';
import 'package:inno_boon_interview/model/signin_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../authenticate/view/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final SignInUserInfo? signInUserInfo;
  final int? index;

  const HomeScreen({super.key, this.signInUserInfo, this.index = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late HomeScreenCubit homeScreenCubit;

  @override
  void initState() {
    super.initState();
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context, listen: false);
   /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("reached init state");
      homeScreenCubit.fetchGitHubProjects(widget.index ?? 0, context);
      ApiService.instance.token ??= StorageService.instance.getTokenValue();
    });*/
    Future.microtask(() {
      print("reached init state");
      ApiService.instance.token ??= StorageService.instance.getTokenValue();
      homeScreenCubit.fetchGitHubProjects(widget.index ?? 0, context);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("reached resume state");
      homeScreenCubit.fetchGitHubProjects(widget.index ?? 0, context);
      ApiService.instance.token ??= StorageService.instance.getTokenValue();
    } else if (state == AppLifecycleState.inactive) {
     // signOut(context);
    }
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await WebViewCookieManager().clearCookies();
    await FirebaseAuth.instance.currentUser?.reload();

    if (!mounted) return;

    StorageService.instance.clearAll();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) =>  LoginScreen()), (route) => false,
    );
  }

  Widget getAppBarWidget() {
    return Container(
      height: 178,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: Color(0xFF706CFF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                AppStrings().appBarTitle,
                style: AppTextStyles().appBarTitleTextStyle,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => signOut(context),
                child: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Hi ${StorageService.instance.getGitHubUserName("userName") ?? ""}",
            style: AppTextStyles().userNameTextStyle,
          ),
        ],
      ),
    );
  }

  Widget repositoryCard(GitHubProject project) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            project.owner?.avatarUrl ??
                "https://cyclr.com/wp-content/uploads/2022/03/ext-495.png",
          ),
          radius: 24,
        ),
        title: Text(project.name ?? "Project Name"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.owner?.login ?? "Owner"),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Visibility: ${project.visibility ?? ""}"),
                Text("Branch: ${project.defaultBranch ?? ""}"),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RepositoryDetailsPage(project),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getAppBarWidget(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Projects",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF27274A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: state is HomeScreenLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is HomeScreenLoaded
                      ? state.projects.isEmpty
                      ? const Center(child: Text("No Projects Available"))
                      : ListView.builder(
                    itemCount: state.projects.length,
                    itemBuilder: (context, index) {
                      return repositoryCard(state.projects[index]);
                    },
                  )
                      : const Center(child: Text("No Prodjects Available")),

                )
              )
            ],
          ),
        );
      },
    );
  }
}
