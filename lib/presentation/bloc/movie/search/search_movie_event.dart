part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();
}

class OnQueryMovieChange extends SearchMovieEvent {
  final String query;
  OnQueryMovieChange(this.query);

  @override
  List<Object?> get props => [query];
}
