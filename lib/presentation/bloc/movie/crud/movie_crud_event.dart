part of 'movie_crud_bloc.dart';

abstract class MovieCrudEvent {}

class AddToWatchlist extends MovieCrudEvent {
  final MovieDetail movie;

  AddToWatchlist(this.movie);
}

class RemoveFromWatchlist extends MovieCrudEvent {
  final MovieDetail movie;

  RemoveFromWatchlist(this.movie);
}

class CheckIsWatchlist extends MovieCrudEvent {
  final int movieId;

  CheckIsWatchlist(this.movieId);
}
