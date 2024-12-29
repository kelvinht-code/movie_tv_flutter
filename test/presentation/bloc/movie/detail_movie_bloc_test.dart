import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/genre.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_movie_detail.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/detail/movie_detail_bloc.dart';

import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  final tId = 1;
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

  group('Movie Detail', () {
    test('initial state should be empty', () {
      expect(movieDetailBloc.state, MovieDetailEmpty());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, HasData] when data movie is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailHasData(tMovieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when data movie is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });
}