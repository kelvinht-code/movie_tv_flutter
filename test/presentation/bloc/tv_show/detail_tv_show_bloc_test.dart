import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_detail.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';

import 'detail_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetTvShowDetail])
void main() {
  late TvShowDetailBloc tvShowDetailBloc;
  late MockGetTvShowDetail mockGetTvShowDetail;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    tvShowDetailBloc = TvShowDetailBloc(mockGetTvShowDetail);
  });

  final tId = 1;
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

  group('TV Show Detail', () {
    test('initial state should be empty', () {
      expect(tvShowDetailBloc.state, TvShowDetailEmpty());
    });

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'Should emit [Loading, HasData] when data movie is gotten successfully',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvShowDetail));
        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowDetailLoading(),
        TvShowDetailHasData(tTvShowDetail),
      ],
      verify: (bloc) {
        verify(mockGetTvShowDetail.execute(tId));
      },
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'Should emit [Loading, Error] when data movie is unsuccessful',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvShowDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowDetailLoading(),
        TvShowDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvShowDetail.execute(tId));
      },
    );
  });
}
