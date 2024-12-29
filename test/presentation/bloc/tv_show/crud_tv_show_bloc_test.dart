import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_show_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/remove_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/save_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/crud/tv_show_crud_bloc.dart';

import 'crud_tv_show_bloc_test.mocks.dart';

@GenerateMocks([
  SaveWatchlistTvShow,
  RemoveWatchlistTvShow,
  GetWatchListTvShowStatus,
])
void main() {
  late TvShowCrudBloc tvShowCrudBloc;

  late MockSaveWatchlistTvShow mockSaveWatchlistTvShow;
  late MockRemoveWatchlistTvShow mockRemoveWatchlistTvShow;
  late MockGetWatchListTvShowStatus mockGetWatchListTvShowStatus;

  setUp(() {
    mockSaveWatchlistTvShow = MockSaveWatchlistTvShow();
    mockRemoveWatchlistTvShow = MockRemoveWatchlistTvShow();
    mockGetWatchListTvShowStatus = MockGetWatchListTvShowStatus();

    tvShowCrudBloc = TvShowCrudBloc(
      saveWatchlistTvShow: mockSaveWatchlistTvShow,
      removeWatchlistTvShow: mockRemoveWatchlistTvShow,
      getWatchListTvShowStatus: mockGetWatchListTvShowStatus,
    );
  });

  final tTvShowDetail = TvShowDetail(
    adult: false,
    backdropPath: "backdropPath",
    episodeRunTime: [],
    firstAirDate: DateTime.parse('2024-12-31'),
    genres: [],
    homepage: "homepage",
    id: 1,
    inProduction: false,
    languages: [],
    lastAirDate: DateTime.parse('2024-12-31'),
    name: "name",
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originCountry: [],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1,
    posterPath: "posterPath",
    seasons: [],
    status: "status",
    tagline: "tagline",
    type: "type",
    voteAverage: 1,
    voteCount: 1,
  );

  group('Save TV Show on Database Local', () {
    test('initial state should be empty', () {
      expect(tvShowCrudBloc.state, TvShowCrudInitial());
    });

    blocTest<TvShowCrudBloc, TvShowCrudState>(
      'Should emit [Loading, Success] when save tv show is gotten successfully',
      build: () {
        when(mockSaveWatchlistTvShow.execute(tTvShowDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        return tvShowCrudBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowCrudLoading(),
        TvShowCrudSuccess('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvShow.execute(tTvShowDetail));
      },
    );

    blocTest<TvShowCrudBloc, TvShowCrudState>(
      'Should emit [Loading, Error] when save tv show is unsuccessful',
      build: () {
        when(mockSaveWatchlistTvShow.execute(tTvShowDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed to add watchlist')));
        return tvShowCrudBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowCrudLoading(),
        TvShowCrudFailure('Failed to add watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvShow.execute(tTvShowDetail));
      },
    );
  });

  group('Remove TV Show on Database Local', () {
    test('initial state should be empty', () {
      expect(tvShowCrudBloc.state, TvShowCrudInitial());
    });

    blocTest<TvShowCrudBloc, TvShowCrudState>(
      'Should emit [Loading, Success] when remove tv show is gotten successfully',
      build: () {
        when(mockRemoveWatchlistTvShow.execute(tTvShowDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        return tvShowCrudBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowCrudLoading(),
        TvShowCrudSuccess('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvShow.execute(tTvShowDetail));
      },
    );

    blocTest<TvShowCrudBloc, TvShowCrudState>(
      'Should emit [Loading, Error] when remove tv show is unsuccessful',
      build: () {
        when(mockRemoveWatchlistTvShow.execute(tTvShowDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed to remove watchlist')));
        return tvShowCrudBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowCrudLoading(),
        TvShowCrudFailure('Failed to remove watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvShow.execute(tTvShowDetail));
      },
    );
  });

  group('Checklist TV Show Watchlist on Database Local', () {
    blocTest<TvShowCrudBloc, TvShowCrudState>(
      'Should emit [Status] when checking watchlist status',
      build: () {
        when(mockGetWatchListTvShowStatus.execute(tTvShowDetail.id))
            .thenAnswer((_) async => true);
        return tvShowCrudBloc;
      },
      act: (bloc) => bloc.add(CheckIsWatchlist(tTvShowDetail.id)),
      expect: () => [
        TvShowCrudStatus(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListTvShowStatus.execute(tTvShowDetail.id));
      },
    );
  });
}
