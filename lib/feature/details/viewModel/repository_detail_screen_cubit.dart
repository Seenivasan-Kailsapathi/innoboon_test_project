import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_boon_interview/core/network/api_service.dart';
import 'package:inno_boon_interview/feature/details/viewModel/repository_detail_screen_states.dart';
import 'package:inno_boon_interview/model/branch_list_model.dart';
import 'package:inno_boon_interview/model/commits_list_model.dart';



class DetailScreenCubit extends Cubit<DetailScreenState> {
  DetailScreenCubit() : super(DetailScreenInitial());

  BranchList? branchList;
  List<Branch> listOfBranches = [];
  List<String?> branches = [];
  Map<String, CommitsList> commitsWithBranch = {};
  CommitsList? displayedCommits;
  int? selectedIndex = 0;

  Future<void> fetchGitHubProjectBranches(
      BuildContext context, String user, String projectName) async {
    emit(DetailScreenLoading());

    try {
      final branchList =
      await ApiService.instance.fetchGitHubProjectBranchesFromApi(
          user, projectName);
      listOfBranches = branchList?.branchList ?? [];
      branches = listOfBranches.map((branch) => branch.name).toList();

      await fetchCommitsForBranches(user, projectName);
      displayedCommits =
      (branches.isEmpty) ? null : commitsWithBranch[branches[0]];

      emit(DetailScreenLoaded());
    } catch (e) {
      emit(DetailScreenError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchCommitsForBranches(
      String user, String projectName) async {
    for (var branch in branches) {
      final commits = await ApiService.instance
          .fetchGitHubProjectCommitsFromApi(user, projectName, branch ?? "");
      if (commits != null) {
        commitsWithBranch[branch ?? ""] = commits;
      }
    }
  }

  void filterCommits(String branchName, int index) {
    displayedCommits = commitsWithBranch[branchName];
    selectedIndex = index;
    emit(DetailScreenLoaded());
  }
}
