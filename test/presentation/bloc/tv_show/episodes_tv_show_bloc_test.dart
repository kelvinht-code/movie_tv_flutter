import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_episode.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_episodes.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/episodes/tv_show_episodes_bloc.dart';

import 'episodes_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetTvShowEpisodes])
void main() {
  late TvShowEpisodesBloc tvShowEpisodesBloc;
  late MockGetTvShowEpisodes mockGetTvShowEpisodes;

  setUp(() {
    mockGetTvShowEpisodes = MockGetTvShowEpisodes();
    tvShowEpisodesBloc = TvShowEpisodesBloc(mockGetTvShowEpisodes);
  });

  final tId = 1;
  final tSeason = 1;
  final tTvShowEpisodes = TvShowEpisode(
    id: "1",
    airDate: DateTime.parse('2024-12-31'),
    episodes: [],
    name: "name",
    overview: "overview",
    tvShowEpisodeResponseId: 1,
    posterPath: "posterPath",
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  group('TV Show Episodes', () {
    test('initial state should be empty', () {
      expect(tvShowEpisodesBloc.state, TvShowEpisodesEmpty());
    });

    blocTest<TvShowEpisodesBloc, TvShowEpisodesState>(
      'Should emit [Loading, HasData] when data tv episode is gotten successfully',
      build: () {
        when(mockGetTvShowEpisodes.execute(tId, tSeason))
            .thenAnswer((_) async => Right(tTvShowEpisodes));
        return tvShowEpisodesBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowEpisodes(tId, tSeason)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowEpisodesLoading(),
        TvShowEpisodesHasData(tTvShowEpisodes),
      ],
      verify: (bloc) {
        verify(mockGetTvShowEpisodes.execute(tId, tSeason));
      },
    );

    blocTest<TvShowEpisodesBloc, TvShowEpisodesState>(
      'Should emit [Loading, Error] when data tv episode is unsuccessful',
      build: () {
        when(mockGetTvShowEpisodes.execute(tId, tSeason))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowEpisodesBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowEpisodes(tId, tSeason)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowEpisodesLoading(),
        TvShowEpisodesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvShowEpisodes.execute(tId, tSeason));
      },
    );
  });
}
