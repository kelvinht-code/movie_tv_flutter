part of 'tv_show_list_bloc.dart';

abstract class TvShowListState extends Equatable {
  const TvShowListState();

  @override
  List<Object?> get props => [];
}

class TvShowListEmpty extends TvShowListState {}

class TvShowListLoading extends TvShowListState {}

class TvShowListError extends TvShowListState {
  final String message;

  TvShowListError(this.message);
}

class TvShowListHasData extends TvShowListState {
  final List<TvShow> result;

  TvShowListHasData(this.result);
}
