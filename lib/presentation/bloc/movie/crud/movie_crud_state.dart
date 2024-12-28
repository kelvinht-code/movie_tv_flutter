part of 'movie_crud_bloc.dart';

abstract class MovieCrudState {}

class MovieCrudInitial extends MovieCrudState {}

class MovieCrudLoading extends MovieCrudState {}

class MovieCrudSuccess extends MovieCrudState {
  final String message;

  MovieCrudSuccess(this.message);
}

class MovieCrudFailure extends MovieCrudState {
  final String message;

  MovieCrudFailure(this.message);
}

class MovieCrudStatus extends MovieCrudState {
  final bool isInWatchlist;

  MovieCrudStatus(this.isInWatchlist);
}
