import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/genre.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_watchlist_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/remove_watchlist.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/save_watchlist.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/crud/movie_crud_bloc.dart';

import 'crud_movie_bloc_test.mocks.dart';

@GenerateMocks([SaveWatchlist, RemoveWatchlist, GetWatchListStatus])
void main() {
  late MovieCrudBloc movieCrudBloc;

  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();

    movieCrudBloc = MovieCrudBloc(
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchListStatus: mockGetWatchListStatus,
    );
  });

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [
      Genre(id: 1, name: 'Action'),
      Genre(id: 2, name: 'Drama'),
    ],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 150,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group('Save Movie on Database Local', () {
    test('initial state should be empty', () {
      expect(movieCrudBloc.state, MovieCrudInitial());
    });

    blocTest<MovieCrudBloc, MovieCrudState>(
      'Should emit [Loading, Success] when save movie is gotten successfully',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        return movieCrudBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieCrudLoading(),
        MovieCrudSuccess('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
      },
    );

    blocTest<MovieCrudBloc, MovieCrudState>(
      'Should emit [Loading, Error] when save movie is unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed to add watchlist')));
        return movieCrudBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieCrudLoading(),
        MovieCrudFailure('Failed to add watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
      },
    );
  });

  group('Remove Movie on Database Local', () {
    test('initial state should be empty', () {
      expect(movieCrudBloc.state, MovieCrudInitial());
    });

    blocTest<MovieCrudBloc, MovieCrudState>(
      'Should emit [Loading, Success] when remove movie is gotten successfully',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        return movieCrudBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieCrudLoading(),
        MovieCrudSuccess('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
      },
    );

    blocTest<MovieCrudBloc, MovieCrudState>(
      'Should emit [Loading, Error] when remove movie is unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('Failed to remove watchlist')));
        return movieCrudBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieCrudLoading(),
        MovieCrudFailure('Failed to remove watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
      },
    );
  });

  group('Checklist Movie Watchlist on Database Local', () {
    blocTest<MovieCrudBloc, MovieCrudState>(
      'Should emit [Status] when checking watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieCrudBloc;
      },
      act: (bloc) => bloc.add(CheckIsWatchlist(tMovieDetail.id)),
      expect: () => [
        MovieCrudStatus(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );
  });
}
