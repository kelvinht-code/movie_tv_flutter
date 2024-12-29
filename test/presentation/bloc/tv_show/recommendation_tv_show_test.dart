import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_recommendations.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/recommendation/tv_show_recommendation_bloc.dart';

import 'recommendation_tv_show_test.mocks.dart';

@GenerateMocks([GetTvShowRecommendations])
void main() {
  late TvShowRecommendationBloc tvShowRecommendationBloc;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;

  setUp(() {
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    tvShowRecommendationBloc =
        TvShowRecommendationBloc(mockGetTvShowRecommendations);
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

  final tId = 1;
  final tTvShowList = <TvShow>[tTvShow];

  group('TV Show Recommendation', () {
    test('initial state should be empty', () {
      expect(tvShowRecommendationBloc.state, TvShowRecommendationEmpty());
    });

    blocTest<TvShowRecommendationBloc, TvShowRecommendationState>(
      'Should emit [Loading, HasData] when data movie is gotten successfully',
      build: () {
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvShowList));
        return tvShowRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowRecommendationLoading(),
        TvShowRecommendationHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetTvShowRecommendations.execute(tId));
      },
    );

    blocTest<TvShowRecommendationBloc, TvShowRecommendationState>(
      'Should emit [Loading, Error] when data movie is unsuccessful',
      build: () {
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowRecommendationLoading(),
        TvShowRecommendationError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvShowRecommendations.execute(tId));
      },
    );
  });
}
