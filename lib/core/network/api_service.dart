import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inno_boon_interview/model/branch_list_model.dart';
import 'package:inno_boon_interview/model/commits_list_model.dart';
import 'package:inno_boon_interview/model/github_projects_model.dart';
import 'package:inno_boon_interview/model/organization_model.dart';
import 'package:inno_boon_interview/model/signin_model.dart';

import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  String? token;

  ApiService._();
  static ApiService instance = ApiService._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com',
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    ),
  );

  Map<String, String> buildHeaders() {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github.v3+json',
    };
  }

  // Fetch GitHub user information
  Future<SignInUserInfo?> fetchGitHubUserDetailsFromApi() async {
    try {
      final response = await dio.get(
        '/user',
        options: Options(headers: buildHeaders()),
      );
      return SignInUserInfo.fromJson(response.data);
    } catch (e) {
      handleError('User Info', e);
      return null;
    }
  }

  // Fetch GitHub user repositories
  Future<GitHubProjects?> fetchGitHubOrganizationProjectsFromApi() async {
    try {
      final response = await dio.get(
        '/user/repos',
        options: Options(headers: buildHeaders()),
      );
      print("the response is:${response.data}");
      return GitHubProjects.fromJson(response.data);
    } catch (e) {
      handleError('Repositories', e);
      return null;
    }
  }

  // Fetch branches of a repo
  Future<BranchList?> fetchGitHubProjectBranchesFromApi(
      String user, String projectName) async {
    try {
      final response = await dio.get(
        '/repos/$user/$projectName/branches',
        options: Options(headers: buildHeaders()),
      );
      return BranchList.fromJson(response.data);
    } catch (e) {
      handleError('Branches', e);
      return null;
    }
  }

  // Fetch commits of a branch
  Future<CommitsList?> fetchGitHubProjectCommitsFromApi(
      String user, String projectName, String branch) async {
    try {
      final response = await dio.get(
        '/repos/$user/$projectName/commits',
        queryParameters: {'sha': branch},
        options: Options(headers: buildHeaders()),
      );
      return CommitsList.fromJson(response.data);
    } catch (e) {
      handleError('Commits', e);
      return null;
    }
  }

  void handleError(String apiName, dynamic error) {
    if (error is DioException) {
      print('$apiName API Error: ${error.response?.statusCode} - ${error.response?.data}');
    } else {
      print('$apiName Unknown Error: $error');
    }
  }
}

