part of 'search_tv_show_bloc.dart';

abstract class SearchTvShowEvent extends Equatable {
  const SearchTvShowEvent();
}

class OnQueryTvShowChange extends SearchTvShowEvent {
  final String query;
  OnQueryTvShowChange(this.query);

  @override
  List<Object?> get props => [query];
}
