part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent {
  const SearchMovieEvent();
}

class OnQueryMovieChange extends SearchMovieEvent {
  final String query;
  OnQueryMovieChange(this.query);
}
