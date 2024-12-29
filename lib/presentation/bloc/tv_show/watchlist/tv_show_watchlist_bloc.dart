import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_shows.dart';

part 'tv_show_watchlist_event.dart';
part 'tv_show_watchlist_state.dart';

class TvShowWatchlistBloc
    extends Bloc<TvShowWatchlistEvent, TvShowWatchlistState> {
  final GetWatchlistTvShows getWatchlistTvShows;

  TvShowWatchlistBloc(this.getWatchlistTvShows)
      : super(TvShowWatchlistEmpty()) {
    on<FetchTvShowWatchlist>((event, emit) async {
      emit(TvShowWatchlistLoading());
      final result = await getWatchlistTvShows.execute();
      result.fold(
        (error) => emit(TvShowWatchlistError(error.message)),
        (data) => emit(TvShowWatchlistHasData(data)),
      );
    });
  }
}
