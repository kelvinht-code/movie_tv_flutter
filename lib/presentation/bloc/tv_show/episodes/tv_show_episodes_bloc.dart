import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_episode.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_episodes.dart';

part 'tv_show_episodes_event.dart';
part 'tv_show_episodes_state.dart';

class TvShowEpisodesBloc
    extends Bloc<TvShowEpisodesEvent, TvShowEpisodesState> {
  final GetTvShowEpisodes getTvShowEpisodes;

  TvShowEpisodesBloc(this.getTvShowEpisodes) : super(TvShowEpisodesEmpty()) {
    on<FetchTvShowEpisodes>((event, emit) async {
      emit(TvShowEpisodesLoading());
      final result = await getTvShowEpisodes.execute(event.id, event.season);
      result.fold(
        (failure) => emit(TvShowEpisodesError(failure.message)),
        (episodes) => emit(TvShowEpisodesHasData(episodes)),
      );
    });
  }
}
