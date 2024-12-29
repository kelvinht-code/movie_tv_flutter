import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/crud/movie_crud_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/recommendation/movie_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_detail_page.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_widget_test.mocks.dart';

@GenerateMocks([
  MovieDetailBloc,
  MovieRecommendationBloc,
  MovieCrudBloc,
])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;
  late MockMovieCrudBloc mockMovieCrudBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
    mockMovieCrudBloc = MockMovieCrudBloc();
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

  void mockStreamLoadingState() {
    // Movie Detail - Mock the state stream to return the loading state
    when(mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(mockMovieDetailBloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailLoading()),
    );

    // Movie Recommendation - Mock the state stream to return the loading state
    when(mockMovieRecommendationBloc.state).thenReturn(
      MovieRecommendationLoading(),
    );
    when(mockMovieRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(MovieRecommendationLoading()),
    );

    // Movie Crud - Mock the state stream to return the loading state
    when(mockMovieCrudBloc.state).thenReturn(MovieCrudLoading());
    when(mockMovieCrudBloc.stream)
        .thenAnswer((_) => Stream.value(MovieCrudLoading()));
  }

  void mockStreamHasDataState() {
    when(mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(mockMovieDetailBloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailHasData(testMovieDetail)),
    );

    when(mockMovieRecommendationBloc.state).thenReturn(
      MovieRecommendationHasData(tMovieList),
    );
    when(mockMovieRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(MovieRecommendationHasData(tMovieList)),
    );

    when(mockMovieCrudBloc.state)
        .thenReturn(MovieCrudSuccess('Added to Watchlist'));
    when(mockMovieCrudBloc.stream).thenAnswer(
        (_) => Stream.value(MovieCrudSuccess('Added to Watchlist')));
  }

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationBloc>.value(
          value: mockMovieRecommendationBloc,
        ),
        BlocProvider<MovieCrudBloc>.value(value: mockMovieCrudBloc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: MovieDetailPage(id: 1),
        ),
      ),
    );
  }

  testWidgets('Should display center when loading get data Movie Detail',
      (WidgetTester tester) async {
    mockStreamLoadingState();

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget());

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    mockStreamHasDataState();
    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(makeTestableWidget());
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    mockStreamHasDataState();

    final watchlistButton = find.byType(FilledButton);
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Should show SnackBar on success when added to watchlist',
      (WidgetTester tester) async {
    mockStreamHasDataState();

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Should display genres correctly', (WidgetTester tester) async {
    mockStreamHasDataState();
    final genresTextFinder = find.text('Action, Drama');
    await tester.pumpWidget(makeTestableWidget());
    expect(genresTextFinder, findsOneWidget);
  });

  testWidgets('Should display duration correctly', (WidgetTester tester) async {
    mockStreamHasDataState();
    final durationTextFinder = find.text('2h 30m');
    await tester.pumpWidget(makeTestableWidget());
    expect(durationTextFinder, findsOneWidget);
  });

  testWidgets('Should display movie rating correctly',
      (WidgetTester tester) async {
    mockStreamHasDataState();
    final ratingFinder = find.text('${testMovieDetail.voteAverage}');
    await tester.pumpWidget(makeTestableWidget());
    expect(ratingFinder, findsOneWidget);
  });

  testWidgets('Should display movie recommendations when loaded',
      (WidgetTester tester) async {
    when(mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(mockMovieDetailBloc.stream).thenAnswer(
      (_) => Stream.value(MovieDetailHasData(testMovieDetail)),
    );
    when(mockMovieRecommendationBloc.state).thenReturn(
      MovieRecommendationLoading(),
    );
    when(mockMovieRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(MovieRecommendationLoading()),
    );

    when(mockMovieCrudBloc.state).thenReturn(MovieCrudLoading());
    when(mockMovieCrudBloc.stream)
        .thenAnswer((_) => Stream.value(MovieCrudLoading()));

    final recommendationFinder = find.byType(CachedNetworkImage);

    await tester.pumpWidget(makeTestableWidget());

    expect(recommendationFinder, findsWidgets);
  });

  testWidgets('Should navigate back when back button is tapped',
      (WidgetTester tester) async {
    mockStreamHasDataState();

    final backButtonFinder = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailPage), findsNothing);
  });
}
