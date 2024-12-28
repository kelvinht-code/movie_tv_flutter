import 'package:bloc/bloc.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_show_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/remove_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/save_watchlist_tv_show.dart';

part 'tv_show_crud_event.dart';
part 'tv_show_crud_state.dart';

class TvShowCrudBloc extends Bloc<TvShowCrudEvent, TvShowCrudState> {
  final SaveWatchlistTvShow saveWatchlistTvShow;
  final RemoveWatchlistTvShow removeWatchlistTvShow;
  final GetWatchListTvShowStatus getWatchListTvShowStatus;

  TvShowCrudBloc({
    required this.saveWatchlistTvShow,
    required this.removeWatchlistTvShow,
    required this.getWatchListTvShowStatus,
  }) : super(TvShowCrudInitial()) {
    on<AddToWatchlist>((event, emit) async {
      emit(TvShowCrudLoading());
      final result = await saveWatchlistTvShow.execute(event.tvShow);
      result.fold(
        (failure) => emit(TvShowCrudFailure(failure.message)),
        (successMessage) => emit(TvShowCrudSuccess(successMessage)),
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      emit(TvShowCrudLoading());
      final result = await removeWatchlistTvShow.execute(event.tvShow);
      result.fold(
        (failure) => emit(TvShowCrudFailure(failure.message)),
        (successMessage) => emit(TvShowCrudSuccess(successMessage)),
      );
    });

    on<CheckIsWatchlist>((event, emit) async {
      final result = await getWatchListTvShowStatus.execute(event.tvShowId);
      emit(TvShowCrudStatus(result));
    });
  }
}
