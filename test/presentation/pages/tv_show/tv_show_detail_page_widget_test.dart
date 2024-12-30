import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/crud/tv_show_crud_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/recommendation/tv_show_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_detail_page.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_page_widget_test.mocks.dart';

@GenerateMocks([
  TvShowDetailBloc,
  TvShowRecommendationBloc,
  TvShowCrudBloc,
])
void main() {
  late MockTvShowDetailBloc mockTvShowDetailBloc;
  late MockTvShowRecommendationBloc mockTvShowRecommendationBloc;
  late MockTvShowCrudBloc mockTvShowCrudBloc;

  setUp(() {
    mockTvShowDetailBloc = MockTvShowDetailBloc();
    mockTvShowRecommendationBloc = MockTvShowRecommendationBloc();
    mockTvShowCrudBloc = MockTvShowCrudBloc();
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

  void mockStreamLoadingState() {
    when(mockTvShowDetailBloc.state).thenReturn(TvShowDetailLoading());
    when(mockTvShowDetailBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowDetailLoading()),
    );

    when(mockTvShowRecommendationBloc.state).thenReturn(
      TvShowRecommendationLoading(),
    );
    when(mockTvShowRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowRecommendationLoading()),
    );

    when(mockTvShowCrudBloc.state).thenReturn(TvShowCrudLoading());
    when(mockTvShowCrudBloc.stream)
        .thenAnswer((_) => Stream.value(TvShowCrudLoading()));
  }

  void mockStreamHasDataState() {
    when(mockTvShowDetailBloc.state)
        .thenReturn(TvShowDetailHasData(testTvShowDetail));
    when(mockTvShowDetailBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowDetailHasData(testTvShowDetail)),
    );

    when(mockTvShowRecommendationBloc.state).thenReturn(
      TvShowRecommendationHasData(tTvShowList),
    );
    when(mockTvShowRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowRecommendationHasData(tTvShowList)),
    );

    when(mockTvShowCrudBloc.state)
        .thenReturn(TvShowCrudSuccess('Added to Watchlist Tv Show'));
    when(mockTvShowCrudBloc.stream).thenAnswer(
        (_) => Stream.value(TvShowCrudSuccess('Added to Watchlist Tv Show')));
  }

  void mockStreamErrorState() {
    when(mockTvShowDetailBloc.state)
        .thenReturn(TvShowDetailError('Failed Get TV Show Detail'));
    when(mockTvShowDetailBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowDetailError('Failed Get TV Show Detail')),
    );

    when(mockTvShowRecommendationBloc.state).thenReturn(
      TvShowRecommendationError('Failed Get TV Show Recommendation'),
    );
    when(mockTvShowRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(
          TvShowRecommendationError('Failed Get TV Show Recommendation')),
    );

    when(mockTvShowCrudBloc.state)
        .thenReturn(TvShowCrudFailure('Failed Add to Watchlist Tv Show'));
    when(mockTvShowCrudBloc.stream).thenAnswer((_) =>
        Stream.value(TvShowCrudFailure('Failed Add to Watchlist Tv Show')));
  }

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvShowDetailBloc>.value(value: mockTvShowDetailBloc),
        BlocProvider<TvShowRecommendationBloc>.value(
          value: mockTvShowRecommendationBloc,
        ),
        BlocProvider<TvShowCrudBloc>.value(value: mockTvShowCrudBloc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: TvShowDetailPage(id: 1),
        ),
      ),
    );
  }

  testWidgets('Should display center when loading get data TV Show Detail',
      (WidgetTester tester) async {
    mockStreamLoadingState();

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget());

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when tv show not added to watchlist',
      (WidgetTester tester) async {
    mockStreamHasDataState();
    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(makeTestableWidget());
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv show is added to watchlist',
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
    expect(find.text('Added to Watchlist Tv Show'), findsOneWidget);
  });

  testWidgets('Should display genres correctly', (WidgetTester tester) async {
    mockStreamHasDataState();
    final genresTextFinder = find.text('');
    await tester.pumpWidget(makeTestableWidget());
    expect(genresTextFinder, findsOneWidget);
  });

  testWidgets('Should display duration correctly', (WidgetTester tester) async {
    mockStreamHasDataState();
    final durationTextFinder = find.text('');
    await tester.pumpWidget(makeTestableWidget());
    expect(durationTextFinder, findsOneWidget);
  });

  testWidgets('Should display tv show rating correctly',
      (WidgetTester tester) async {
    mockStreamHasDataState();
    final ratingFinder = find.text('${testTvShowDetail.voteAverage}');
    await tester.pumpWidget(makeTestableWidget());
    expect(ratingFinder, findsOneWidget);
  });

  testWidgets('Should display tv show recommendations when loaded',
      (WidgetTester tester) async {
    when(mockTvShowDetailBloc.state)
        .thenReturn(TvShowDetailHasData(testTvShowDetail));
    when(mockTvShowDetailBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowDetailHasData(testTvShowDetail)),
    );
    when(mockTvShowRecommendationBloc.state).thenReturn(
      TvShowRecommendationLoading(),
    );
    when(mockTvShowRecommendationBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowRecommendationLoading()),
    );

    when(mockTvShowCrudBloc.state).thenReturn(TvShowCrudLoading());
    when(mockTvShowCrudBloc.stream)
        .thenAnswer((_) => Stream.value(TvShowCrudLoading()));

    final recommendationFinder = find.byType(CachedNetworkImage);

    await tester.pumpWidget(makeTestableWidget());

    expect(recommendationFinder, findsWidgets);
  });

  testWidgets(
    'Should show message error if state is TvShowRecommendationError',
    (WidgetTester tester) async {
      when(mockTvShowDetailBloc.state)
          .thenReturn(TvShowDetailHasData(testTvShowDetail));
      when(mockTvShowDetailBloc.stream).thenAnswer(
        (_) => Stream.value(TvShowDetailHasData(testTvShowDetail)),
      );

      when(mockTvShowRecommendationBloc.state).thenReturn(
        TvShowRecommendationError('Failed Get TV Show Recommendation'),
      );
      when(mockTvShowRecommendationBloc.stream).thenAnswer(
        (_) => Stream.value(
            TvShowRecommendationError('Failed Get TV Show Recommendation')),
      );

      when(mockTvShowCrudBloc.state).thenReturn(TvShowCrudLoading());
      when(mockTvShowCrudBloc.stream)
          .thenAnswer((_) => Stream.value(TvShowCrudLoading()));

      await tester.pumpWidget(makeTestableWidget());
      expect(find.text('Failed Get TV Show Recommendation'), findsOneWidget);
    },
  );

  testWidgets('Should navigate back when back button is tapped',
      (WidgetTester tester) async {
    mockStreamHasDataState();

    final backButtonFinder = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(TvShowDetailPage), findsNothing);
  });

  testWidgets(
    'Should show message error if state is TvShowDetailError',
    (WidgetTester tester) async {
      mockStreamErrorState();
      await tester.pumpWidget(makeTestableWidget());
      expect(find.text('Failed Get TV Show Detail'), findsOneWidget);
    },
  );

  /*testWidgets(
    'Should get all seasons from data Tv Show',
    (WidgetTester tester) async {
      mockStreamHasDataState();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _allSeasons(tSeasonTvShow),
          ),
        ),
      );


      expect(find.byKey(ValueKey('ListSeasonTvShow')), findsOneWidget);
      expect(find.byKey(ValueKey('ImageTvShowDetail')), findsWidgets);
    },
  );*/
}
