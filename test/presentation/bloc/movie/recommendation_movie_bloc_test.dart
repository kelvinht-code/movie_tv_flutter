import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_movie_recommendations.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/recommendation/movie_recommendation_bloc.dart';

import 'recommendation_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationBloc movieRecommendationBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationBloc =
        MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  final tMovie1 = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tId = 1;
  final tMovieList = <Movie>[tMovie1];

  group('Movie Recommendation', () {
    test('initial state should be empty', () {
      expect(movieRecommendationBloc.state, MovieRecommendationEmpty());
    });

    blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit [Loading, HasData] when data movie is gotten successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return movieRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieRecommendationLoading(),
        MovieRecommendationHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit [Loading, Error] when data movie is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieRecommendationLoading(),
        MovieRecommendationError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });
}
