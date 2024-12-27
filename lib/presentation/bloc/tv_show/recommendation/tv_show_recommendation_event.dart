part of 'tv_show_recommendation_bloc.dart';

abstract class TvShowRecommendationEvent {}

class FetchTvShowRecommendation extends TvShowRecommendationEvent {
  final int id;

  FetchTvShowRecommendation(this.id);
}
