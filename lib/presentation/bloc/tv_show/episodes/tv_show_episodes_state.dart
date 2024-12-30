part of 'tv_show_episodes_bloc.dart';

abstract class TvShowEpisodesState extends Equatable {
  const TvShowEpisodesState();

  @override
  List<Object?> get props => [];
}

class TvShowEpisodesEmpty extends TvShowEpisodesState {}

class TvShowEpisodesLoading extends TvShowEpisodesState {}

class TvShowEpisodesError extends TvShowEpisodesState {
  final String message;

  const TvShowEpisodesError(this.message);
}

class TvShowEpisodesHasData extends TvShowEpisodesState {
  final TvShowEpisode result;

  const TvShowEpisodesHasData(this.result);
}
