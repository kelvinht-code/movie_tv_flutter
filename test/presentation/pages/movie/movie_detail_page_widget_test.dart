import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/crud/movie_crud_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/recommendation/movie_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_detail_page.dart';
import 'package:provider/provider.dart';

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
    //final tId = 1;

    // // Movie Detail - Mock the state stream to return the loading state
    // when(mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    // when(mockMovieDetailBloc.stream).thenAnswer(
    //   (_) => Stream.value(MovieDetailLoading()),
    // );
    //
    // // Movie Recommendation - Mock the state stream to return the loading state
    // when(mockMovieRecommendationBloc.state).thenReturn(
    //   MovieRecommendationLoading(),
    // );
    // when(mockMovieRecommendationBloc.stream).thenAnswer(
    //   (_) => Stream.value(MovieRecommendationLoading()),
    // );
    //
    // // Movie Crud - Mock the state stream to return the loading state
    // when(mockMovieCrudBloc.state).thenReturn(MovieCrudLoading());
    // when(mockMovieCrudBloc.stream)
    //     .thenAnswer((_) => Stream.value(MovieCrudLoading()));

    mockStreamLoadingState();

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    // await tester.pumpWidget(
    //   MultiBlocProvider(
    //     providers: [
    //       BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
    //       BlocProvider<MovieRecommendationBloc>.value(
    //         value: mockMovieRecommendationBloc,
    //       ),
    //       BlocProvider<MovieCrudBloc>.value(value: mockMovieCrudBloc),
    //     ],
    //     child: MaterialApp(
    //       home: Scaffold(
    //         body: MovieDetailPage(id: 1),
    //       ),
    //     ),
    //   ),
    // );

    await tester.pumpWidget(makeTestableWidget());

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  
}
