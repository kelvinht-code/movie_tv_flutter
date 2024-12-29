part of 'tv_show_episodes_bloc.dart';

abstract class TvShowEpisodesEvent {}

class FetchTvShowEpisodes extends TvShowEpisodesEvent {
  final int id;
  final int season;

  FetchTvShowEpisodes(this.id, this.season);
}
