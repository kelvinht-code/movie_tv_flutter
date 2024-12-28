part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent {}

class FetchMovieRecommendation extends MovieRecommendationEvent {
  final int id;

  FetchMovieRecommendation(this.id);
}
