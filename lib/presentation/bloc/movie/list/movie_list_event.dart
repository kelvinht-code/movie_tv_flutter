part of 'movie_list_bloc.dart';

abstract class MovieListEvent {}

class FetchNowPlayingMovies extends MovieListEvent {}

class FetchPopularMovies extends MovieListEvent {}

class FetchTopRatedMovies extends MovieListEvent {}
