part of 'tv_show_crud_bloc.dart';

abstract class TvShowCrudState {}

class TvShowCrudInitial extends TvShowCrudState {}

class TvShowCrudLoading extends TvShowCrudState {}

class TvShowCrudSuccess extends TvShowCrudState {
  final String message;

  TvShowCrudSuccess(this.message);
}

class TvShowCrudFailure extends TvShowCrudState {
  final String message;

  TvShowCrudFailure(this.message);
}

class TvShowCrudStatus extends TvShowCrudState {
  final bool isInWatchlist;

  TvShowCrudStatus(this.isInWatchlist);
}

