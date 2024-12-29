import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_episode.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/episodes/tv_show_episodes_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_episodes_body_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_episodes_page.dart';

import 'tv_show_episodes_page_widget_test.mocks.dart';

@GenerateMocks([TvShowEpisodesBloc])
void main() {
  late MockTvShowEpisodesBloc mockTvShowEpisodesBloc;

  setUp(() {
    mockTvShowEpisodesBloc = MockTvShowEpisodesBloc();
  });

  final tvShowEpisode1 = TvShowEpisode(
    id: "1",
    airDate: DateTime.parse('2024-12-31'),
    episodes: [],
    name: "name",
    overview: "overview",
    tvShowEpisodeResponseId: 1,
    posterPath: "posterPath",
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  void mockStreamLoadingState() {
    when(mockTvShowEpisodesBloc.state).thenReturn(TvShowEpisodesLoading());
    when(mockTvShowEpisodesBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowEpisodesLoading()),
    );
  }

  void mockStreamHasDataState() {
    when(mockTvShowEpisodesBloc.state)
        .thenReturn(TvShowEpisodesHasData(tvShowEpisode1));
    when(mockTvShowEpisodesBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowEpisodesHasData(tvShowEpisode1)),
    );
  }

  void mockStreamErrorState() {
    when(mockTvShowEpisodesBloc.state)
        .thenReturn(TvShowEpisodesError('Error occurred'));
    when(mockTvShowEpisodesBloc.stream).thenAnswer(
      (_) => Stream.value(TvShowEpisodesError('Error occurred')),
    );
  }

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvShowEpisodesBloc>.value(value: mockTvShowEpisodesBloc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: TvShowEpisodesPage(id: 1, season: 1),
        ),
      ),
    );
  }

  testWidgets('Should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    mockStreamLoadingState();
    await tester.pumpWidget(makeTestableWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display tv show episodes when data is loaded',
      (WidgetTester tester) async {
    mockStreamHasDataState();
    await tester.pumpWidget(makeTestableWidget());
    expect(find.byType(TvShowEpisodesBodyPage), findsOneWidget);
  });

  testWidgets('Should display error message when data is Error',
      (WidgetTester tester) async {
    mockStreamErrorState();
    await tester.pumpWidget(makeTestableWidget());
    expect(find.text('Error occurred'), findsOneWidget);
  });
}
