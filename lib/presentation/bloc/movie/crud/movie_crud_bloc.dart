import 'package:bloc/bloc.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_watchlist_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/remove_watchlist.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/save_watchlist.dart';

part 'movie_crud_event.dart';
part 'movie_crud_state.dart';

class MovieCrudBloc extends Bloc<MovieCrudEvent, MovieCrudState> {
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetWatchListStatus getWatchListStatus;

  MovieCrudBloc({
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchListStatus,
  }) : super(MovieCrudInitial()) {
    on<AddToWatchlist>((event, emit) async {
      emit(MovieCrudLoading());
      final result = await saveWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(MovieCrudFailure(failure.message)),
        (successMessage) => emit(MovieCrudSuccess(successMessage)),
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      emit(MovieCrudLoading());
      final result = await removeWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(MovieCrudFailure(failure.message)),
        (successMessage) => emit(MovieCrudSuccess(successMessage)),
      );
    });

    on<CheckIsWatchlist>((event, emit) async {
      final result = await getWatchListStatus.execute(event.movieId);
      emit(MovieCrudStatus(result));
    });
  }
}
