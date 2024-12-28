part of 'tv_show_crud_bloc.dart';

abstract class TvShowCrudEvent {}

class AddToWatchlist extends TvShowCrudEvent {
  final TvShowDetail tvShow;

  AddToWatchlist(this.tvShow);
}

class RemoveFromWatchlist extends TvShowCrudEvent {
  final TvShowDetail tvShow;

  RemoveFromWatchlist(this.tvShow);
}

class CheckIsWatchlist extends TvShowCrudEvent {
  final int tvShowId;

  CheckIsWatchlist(this.tvShowId);
}
