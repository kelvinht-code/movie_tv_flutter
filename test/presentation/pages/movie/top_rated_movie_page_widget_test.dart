import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/top_rated_movies_page.dart';

import 'top_rated_movie_page_widget_test.mocks.dart';

@GenerateMocks([TopRatedMovieBloc])
void main() {
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;

  setUp(() {
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
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

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TopRatedMovieBloc>(
        create: (_) => mockTopRatedMovieBloc,
        child: const TopRatedMoviesPage(),
      ),
    );
  }

  testWidgets('Initial for Empty State', (WidgetTester tester) async {
    when(mockTopRatedMovieBloc.state).thenReturn(MovieListEmpty());
    when(mockTopRatedMovieBloc.stream).thenAnswer(
      (_) => Stream.value(MovieListEmpty()),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('Should show CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(mockTopRatedMovieBloc.state).thenReturn(MovieListLoading());
    when(mockTopRatedMovieBloc.stream).thenAnswer(
      (_) => Stream.value(MovieListLoading()),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show movies list when data is available',
      (WidgetTester tester) async {
    when(mockTopRatedMovieBloc.state).thenReturn(MovieListHasData(tMovieList));
    when(mockTopRatedMovieBloc.stream).thenAnswer(
      (_) => Stream.value(MovieListHasData(tMovieList)),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CachedNetworkImage), findsWidgets);

    // For data movie 1
    expect(find.text('title'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);

    // For data movie 2
    expect(find.text('title2'), findsOneWidget);
    expect(find.text('overview2'), findsOneWidget);
  });

  testWidgets('Should show error message when there is an error',
      (WidgetTester tester) async {
    when(mockTopRatedMovieBloc.state)
        .thenReturn(MovieListError('An error occurred'));
    when(mockTopRatedMovieBloc.stream).thenAnswer(
      (_) => Stream.value(MovieListError('An error occurred')),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('An error occurred'), findsOneWidget);
  });
}
