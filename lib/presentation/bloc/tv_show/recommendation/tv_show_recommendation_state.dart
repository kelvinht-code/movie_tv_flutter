part of 'tv_show_recommendation_bloc.dart';

abstract class TvShowRecommendationState extends Equatable {
  const TvShowRecommendationState();

  @override
  List<Object?> get props => [];
}

class TvShowRecommendationEmpty extends TvShowRecommendationState {}

class TvShowRecommendationLoading extends TvShowRecommendationState {}

class TvShowRecommendationError extends TvShowRecommendationState {
  final String message;

  TvShowRecommendationError(this.message);
}

class TvShowRecommendationHasData extends TvShowRecommendationState {
  final List<TvShow> result;

  TvShowRecommendationHasData(this.result);
}
