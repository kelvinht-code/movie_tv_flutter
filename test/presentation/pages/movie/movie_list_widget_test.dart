import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/genre.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_movie_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_movie_recommendations.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_watchlist_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/remove_watchlist.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/save_watchlist.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/crud/movie_crud_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/recommendation/movie_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_detail_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_list_widget.dart';
import 'package:provider/provider.dart';

import 'movie_list_widget_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  SaveWatchlist,
  RemoveWatchlist,
  GetWatchListStatus,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchListStatus mockGetWatchListStatus;

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

  final tMovie2 = Movie(
    adult: false,
    backdropPath: 'backdropPath2',
    genreIds: [1, 2, 3],
    id: 2,
    originalTitle: 'originalTitle2',
    overview: 'overview2',
    popularity: 2,
    posterPath: 'posterPath2',
    releaseDate: 'releaseDate2',
    title: 'title2',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie1, tMovie2];

  final testMovieDetail1 = MovieDetail(
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

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();

    when(mockGetMovieDetail.execute(any))
        .thenAnswer((_) async => Right(testMovieDetail1));

    when(mockGetMovieRecommendations.execute(any))
        .thenAnswer((_) async => Right(tMovieList));

    when(mockGetWatchListStatus.execute(0))
        .thenAnswer((_) async => false);

    when(mockGetWatchListStatus.execute(1))
        .thenAnswer((_) async => false); // Ensure this is included if needed
  });

  testWidgets('MovieList displays list of movies correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/detail': (context) => MultiProvider(
                providers: [
                  BlocProvider<MovieDetailBloc>(
                    create: (_) => MovieDetailBloc(mockGetMovieDetail),
                  ),
                  BlocProvider<MovieRecommendationBloc>(
                    create: (_) =>
                        MovieRecommendationBloc(mockGetMovieRecommendations),
                  ),
                  BlocProvider<MovieCrudBloc>(
                    create: (_) => MovieCrudBloc(
                      saveWatchlist: mockSaveWatchlist,
                      removeWatchlist: mockRemoveWatchlist,
                      getWatchListStatus: mockGetWatchListStatus,
                    ),
                  ),
                ],
                child: MovieDetailPage(id: tMovieList[0].id),
              ),
        },
        home: Scaffold(
          body: MovieList(tMovieList),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ClipRRect), findsNWidgets(tMovieList.length));
    expect(find.byType(CachedNetworkImage), findsNWidgets(tMovieList.length));

    await tester.tap(find.byType(InkWell).first);
    await tester.pump(Duration(seconds: 1)); // Pump once before settling
    //await tester.pumpAndSettle(Duration(seconds: 5)); // Wait for all animations and futures to complete

    //expect(find.byType(MovieDetailPage), findsOneWidget);
  });
}
