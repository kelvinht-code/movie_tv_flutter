import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/search_tv_shows.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/search/search_tv_show_bloc.dart';

import 'search_tv_show_bloc_test.mocks.dart';

@GenerateMocks([SearchTvShows])
void main() {
  late SearchTvShowBloc searchTvShowBloc;
  late MockSearchTvShows mockSearchTvShows;

  setUp(() {
    mockSearchTvShows = MockSearchTvShows();
    searchTvShowBloc = SearchTvShowBloc(mockSearchTvShows);
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
  final tQuery = 'avatar';

  test('initial state should be empty', () {
    expect(searchTvShowBloc.state, SearchTvShowEmpty());
  });

  blocTest<SearchTvShowBloc, SearchTvShowState>(
    'Should emit [Loading, HasData] when data tv show is gotten successfully',
    build: () {
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      return searchTvShowBloc;
    },
    act: (bloc) => bloc.add(OnQueryTvShowChange(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvShowLoading(),
      SearchTvShowHasData(tTvShowList),
    ],
    verify: (bloc) {
      verify(mockSearchTvShows.execute(tQuery));
    },
  );

  blocTest<SearchTvShowBloc, SearchTvShowState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchTvShowBloc;
    },
    act: (bloc) => bloc.add(OnQueryTvShowChange(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvShowLoading(),
      SearchTvShowError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvShows.execute(tQuery));
    },
  );
}
