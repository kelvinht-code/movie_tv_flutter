part of 'tv_show_detail_bloc.dart';

abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object?> get props => [];
}

class TvShowDetailEmpty extends TvShowDetailState {}

class TvShowDetailLoading extends TvShowDetailState {}

class TvShowDetailError extends TvShowDetailState {
  final String message;

  const TvShowDetailError(this.message);
}

class TvShowDetailHasData extends TvShowDetailState {
  final TvShowDetail result;

  const TvShowDetailHasData(this.result);
}
