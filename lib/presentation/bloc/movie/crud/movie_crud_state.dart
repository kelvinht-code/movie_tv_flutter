part of 'movie_crud_bloc.dart';

abstract class MovieCrudState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieCrudInitial extends MovieCrudState {}

class MovieCrudLoading extends MovieCrudState {}

class MovieCrudSuccess extends MovieCrudState {
  final String message;

  MovieCrudSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieCrudFailure extends MovieCrudState {
  final String message;

  MovieCrudFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieCrudStatus extends MovieCrudState {
  final bool isInWatchlist;

  MovieCrudStatus(this.isInWatchlist);

  @override
  List<Object?> get props => [isInWatchlist];
}
