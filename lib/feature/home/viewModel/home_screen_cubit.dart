import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_boon_interview/core/network/api_service.dart';
import 'package:inno_boon_interview/model/github_projects_model.dart';
import 'package:inno_boon_interview/model/organization_model.dart';
import 'package:inno_boon_interview/feature/authenticate/view/login_screen.dart';


import 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());

  List<Organization> listOfOrganizations = [];
  Organizations? organizations;
  GitHubProjects? gitHubProjects;
  List<GitHubProject> listOfGithubProjects = [];
  bool isLoad = false;


  Future<void> fetchGitHubProjects(int index, BuildContext context) async {
    try {
      emit(HomeScreenLoading());
      gitHubProjects = await ApiService.instance.fetchGitHubOrganizationProjectsFromApi();
      listOfGithubProjects = gitHubProjects?.gitHubProjectList ?? [];
      print("list: ${listOfGithubProjects.length}");
      emit(HomeScreenLoaded(listOfGithubProjects));
    } catch (e) {
      emit(HomeScreenError(errorMessage: e.toString()));
    }
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }
}
