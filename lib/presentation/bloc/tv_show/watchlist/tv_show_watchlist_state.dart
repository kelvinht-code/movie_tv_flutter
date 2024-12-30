part of 'tv_show_watchlist_bloc.dart';

abstract class TvShowWatchlistState extends Equatable {
  const TvShowWatchlistState();

  @override
  List<Object?> get props => [];
}

class TvShowWatchlistEmpty extends TvShowWatchlistState {}

class TvShowWatchlistLoading extends TvShowWatchlistState {}

class TvShowWatchlistError extends TvShowWatchlistState {
  final String message;

  const TvShowWatchlistError(this.message);
}

class TvShowWatchlistHasData extends TvShowWatchlistState {
  final List<TvShow> result;

  const TvShowWatchlistHasData(this.result);
}
