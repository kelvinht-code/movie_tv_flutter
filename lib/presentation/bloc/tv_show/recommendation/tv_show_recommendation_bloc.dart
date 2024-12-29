import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_recommendations.dart';

part 'tv_show_recommendation_event.dart';
part 'tv_show_recommendation_state.dart';

class TvShowRecommendationBloc
    extends Bloc<TvShowRecommendationEvent, TvShowRecommendationState> {
  final GetTvShowRecommendations getTvShowRecommendations;

  TvShowRecommendationBloc(this.getTvShowRecommendations)
      : super(TvShowRecommendationEmpty()) {
    on<FetchTvShowRecommendation>((event, emit) async {
      emit(TvShowRecommendationLoading());
      final result = await getTvShowRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(TvShowRecommendationError(failure.message)),
        (tvShows) => emit(TvShowRecommendationHasData(tvShows)),
      );
    });
  }
}
