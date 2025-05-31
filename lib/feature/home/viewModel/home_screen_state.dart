
import '../../../model/github_projects_model.dart';

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<GitHubProject> projects;

  HomeScreenLoaded(this.projects);
}

class HomeScreenError extends HomeScreenState {
  final String errorMessage;
  HomeScreenError({required this.errorMessage});
}
