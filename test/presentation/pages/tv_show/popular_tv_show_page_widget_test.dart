import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/list/tv_show_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/popular_tv_shows_page.dart';

import 'popular_tv_show_page_widget_test.mocks.dart';

@GenerateMocks([PopularTvShowBloc])
void main() {
  late MockPopularTvShowBloc mockPopularTvShowBloc;
  
  setUp(() {
    mockPopularTvShowBloc = MockPopularTvShowBloc();
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

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<PopularTvShowBloc>(
        create: (_) => mockPopularTvShowBloc,
        child: const PopularTvShowsPage(),
      ),
    );
  }

  testWidgets('Initial for Empty State', (WidgetTester tester) async {
    when(mockPopularTvShowBloc.state).thenReturn(TvShowListEmpty());
    when(mockPopularTvShowBloc.stream).thenAnswer(
          (_) => Stream.value(TvShowListEmpty()),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('Should show CircularProgressIndicator when loading',
          (WidgetTester tester) async {
        when(mockPopularTvShowBloc.state).thenReturn(TvShowListLoading());
        when(mockPopularTvShowBloc.stream).thenAnswer(
              (_) => Stream.value(TvShowListLoading()),
        );

        await tester.pumpWidget(makeTestableWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('Should show tv show list when data is available',
          (WidgetTester tester) async {
        when(mockPopularTvShowBloc.state)
            .thenReturn(TvShowListHasData(tTvShowList));
        when(mockPopularTvShowBloc.stream).thenAnswer(
              (_) => Stream.value(TvShowListHasData(tTvShowList)),
        );

        await tester.pumpWidget(makeTestableWidget());

        expect(find.byType(CachedNetworkImage), findsWidgets);

        expect(find.text('name'), findsOneWidget);
        expect(find.text('overview'), findsOneWidget);
      });

  testWidgets('Should show error message when there is an error',
          (WidgetTester tester) async {
        when(mockPopularTvShowBloc.state)
            .thenReturn(TvShowListError('An error occurred'));
        when(mockPopularTvShowBloc.stream).thenAnswer(
              (_) => Stream.value(TvShowListError('An error occurred')),
        );

        await tester.pumpWidget(makeTestableWidget());

        expect(find.text('An error occurred'), findsOneWidget);
      });
}