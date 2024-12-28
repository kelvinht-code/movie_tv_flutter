import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_watchlist_movies.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;

  MovieWatchlistBloc(this.getWatchlistMovies) : super(MovieWatchlistEmpty()) {
    on<FetchMovieWatchlist>((event, emit) async {
      emit(MovieWatchlistLoading());
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(MovieWatchlistError(failure.message)),
        (movies) => emit(MovieWatchlistHasData(movies)),
      );
    });
  }
}
