part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationState extends Equatable {
  const MovieRecommendationState();

  @override
  List<Object?> get props => [];
}

class MovieRecommendationEmpty extends MovieRecommendationState {}

class MovieRecommendationLoading extends MovieRecommendationState {}

class MovieRecommendationError extends MovieRecommendationState {
  final String message;

  MovieRecommendationError(this.message);
}

class MovieRecommendationHasData extends MovieRecommendationState {
  final List<Movie> result;

  MovieRecommendationHasData(this.result);
}
