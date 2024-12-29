import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/common/failure.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_watchlist_movies.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/watchlist/movie_watchlist_bloc.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    movieWatchlistBloc = MovieWatchlistBloc(mockGetWatchlistMovies);
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

  final tMovieList = <Movie>[tMovie1];

  group('Movie Watchlist', () {
    test('initial state should be empty', () {
      expect(movieWatchlistBloc.state, MovieWatchlistEmpty());
    });

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, HasData] when data movie is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchMovieWatchlist()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, Error] when data movie is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchMovieWatchlist()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}