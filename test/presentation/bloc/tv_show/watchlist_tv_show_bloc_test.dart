import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_shows.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/watchlist/tv_show_watchlist_bloc.dart';

import 'watchlist_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvShows])
void main() {
  late TvShowWatchlistBloc tvShowWatchlistBloc;
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;
  
  setUp(() {
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    tvShowWatchlistBloc = TvShowWatchlistBloc(mockGetWatchlistTvShows);
  });

  final tTvShow = TvShow(
    adult: false,
    backdropPath: "backdropPath",
    firstAirDate: DateTime.parse('2024-12-31'),
    id: 1,
    name: "name",
    originCountry: [],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1,
    voteCount: 1,
    genreIds: [],
  );

  final tTvShowList = <TvShow>[tTvShow];

  group('TV Show Watchlist', () {
    test('initial state should be empty', () {
      expect(tvShowWatchlistBloc.state, TvShowWatchlistEmpty());
    });

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [Loading, HasData] when data tv show is gotten successfully',
      build: () {
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowWatchlist()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowWatchlistLoading(),
        TvShowWatchlistHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvShows.execute());
      },
    );

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [Loading, Error] when data tv show is unsuccessful',
      build: () {
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowWatchlist()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowWatchlistLoading(),
        TvShowWatchlistError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvShows.execute());
      },
    );
  });
}