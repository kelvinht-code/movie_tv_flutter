part of 'search_tv_show_bloc.dart';

abstract class SearchTvShowState extends Equatable {
  const SearchTvShowState();

  @override
  List<Object?> get props => [];
}

class SearchTvShowEmpty extends SearchTvShowState {}

class SearchTvShowLoading extends SearchTvShowState {}

class SearchTvShowError extends SearchTvShowState {
  final String message;

  SearchTvShowError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchTvShowHasData extends SearchTvShowState {
  final List<TvShow> result;

  SearchTvShowHasData(this.result);

  @override
  List<Object?> get props => [result];
}
