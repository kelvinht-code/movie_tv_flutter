import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_now_playing_movies.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_popular_movies.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_top_rated_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class NowPlayingMovieBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc(this.getNowPlayingMovies) : super(MovieListEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}

class PopularMovieBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieBloc(this.getPopularMovies) : super(MovieListEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}

class TopRatedMovieBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMovieBloc(this.getTopRatedMovies) : super(MovieListEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
