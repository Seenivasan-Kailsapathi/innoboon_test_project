abstract class DetailScreenState {}

class DetailScreenInitial extends DetailScreenState {}

class DetailScreenLoading extends DetailScreenState {}

class DetailScreenLoaded extends DetailScreenState {}

class DetailScreenError extends DetailScreenState {
  final String errorMessage;
  DetailScreenError({required this.errorMessage});
}
