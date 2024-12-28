import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_movie_recommendations.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc(this.getMovieRecommendations)
      : super(MovieRecommendationEmpty()) {
    on<FetchMovieRecommendation>((event, emit) async {
      emit(MovieRecommendationLoading());
      final result = await getMovieRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(MovieRecommendationError(failure.message)),
        (movies) => emit(MovieRecommendationHasData(movies)),
      );
    });
  }
}
