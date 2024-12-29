import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_airing_today.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_on_the_air.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_popular.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_top_rated.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/list/tv_show_list_bloc.dart';

import 'list_tv_show_bloc_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTvShow,
  GetOnTheAirTvShow,
  GetPopularTvShow,
  GetTopRatedTvShow,
])
void main() {
  late MockGetAiringTodayTvShow mockGetAiringTodayTvShow;
  late MockGetOnTheAirTvShow mockGetOnTheAirTvShow;
  late MockGetPopularTvShow mockGetPopularTvShow;
  late MockGetTopRatedTvShow mockGetTopRatedTvShow;

  late AiringTodayTvShowBloc airingTodayTvShowBloc;
  late OnTheAirTvShowBloc onTheAirTvShowBloc;
  late PopularTvShowBloc popularTvShowBloc;
  late TopRatedTvShowBloc topRatedTvShowBloc;

  setUp(() {
    mockGetAiringTodayTvShow = MockGetAiringTodayTvShow();
    airingTodayTvShowBloc = AiringTodayTvShowBloc(mockGetAiringTodayTvShow);

    mockGetOnTheAirTvShow = MockGetOnTheAirTvShow();
    onTheAirTvShowBloc = OnTheAirTvShowBloc(mockGetOnTheAirTvShow);

    mockGetPopularTvShow = MockGetPopularTvShow();
    popularTvShowBloc = PopularTvShowBloc(mockGetPopularTvShow);

    mockGetTopRatedTvShow = MockGetTopRatedTvShow();
    topRatedTvShowBloc = TopRatedTvShowBloc(mockGetTopRatedTvShow);
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

  group('Airing Today TV Show Bloc', () {
    test('Initial state should be empty', () {
      expect(airingTodayTvShowBloc.state, TvShowListEmpty());
    });

    blocTest<AiringTodayTvShowBloc, TvShowListState>(
      'Should emit [Loading, HasData] when data tv show is gotten successfully',
      build: () {
        when(mockGetAiringTodayTvShow.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return airingTodayTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetAiringTodayTvShow.execute());
      },
    );

    blocTest<AiringTodayTvShowBloc, TvShowListState>(
      'Should emit [Loading, Error] when data tv show is unsuccessful',
      build: () {
        when(mockGetAiringTodayTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return airingTodayTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetAiringTodayTvShow.execute());
      },
    );
  });

  group('On The Air TV Show Bloc', () {
    test('Initial state should be empty', () {
      expect(onTheAirTvShowBloc.state, TvShowListEmpty());
    });

    blocTest<OnTheAirTvShowBloc, TvShowListState>(
      'Should emit [Loading, HasData] when data tv show is gotten successfully',
      build: () {
        when(mockGetOnTheAirTvShow.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return onTheAirTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTvShow.execute());
      },
    );

    blocTest<OnTheAirTvShowBloc, TvShowListState>(
      'Should emit [Loading, Error] when data tv show is unsuccessful',
      build: () {
        when(mockGetOnTheAirTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return onTheAirTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirTvShow.execute());
      },
    );
  });

  group('Popular TV Show Bloc', () {
    test('Initial state should be empty', () {
      expect(popularTvShowBloc.state, TvShowListEmpty());
    });

    blocTest<PopularTvShowBloc, TvShowListState>(
      'Should emit [Loading, HasData] when data tv show is gotten successfully',
      build: () {
        when(mockGetPopularTvShow.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return popularTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvShow.execute());
      },
    );

    blocTest<PopularTvShowBloc, TvShowListState>(
      'Should emit [Loading, Error] when data tv show is unsuccessful',
      build: () {
        when(mockGetPopularTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvShow.execute());
      },
    );
  });

  group('Top Rated TV Show Bloc', () {
    test('Initial state should be empty', () {
      expect(topRatedTvShowBloc.state, TvShowListEmpty());
    });

    blocTest<TopRatedTvShowBloc, TvShowListState>(
      'Should emit [Loading, HasData] when data tv show is gotten successfully',
      build: () {
        when(mockGetTopRatedTvShow.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return topRatedTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvShow.execute());
      },
    );

    blocTest<TopRatedTvShowBloc, TvShowListState>(
      'Should emit [Loading, Error] when data tv show is unsuccessful',
      build: () {
        when(mockGetTopRatedTvShow.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTvShowBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoading(),
        TvShowListError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvShow.execute());
      },
    );
  });
}
