import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_recommendations.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_show_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/remove_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/save_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/crud/tv_show_crud_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/recommendation/tv_show_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_detail_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_list_widget.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../bloc/tv_show/crud_tv_show_bloc_test.mocks.dart';
import '../../bloc/tv_show/detail_tv_show_bloc_test.mocks.dart';
import '../../bloc/tv_show/recommendation_tv_show_test.mocks.dart';

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecommendations,
  SaveWatchlistTvShow,
  RemoveWatchlistTvShow,
  GetWatchListTvShowStatus,
])
void main() {
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;
  late MockSaveWatchlistTvShow mockSaveWatchlistTvShow;
  late MockRemoveWatchlistTvShow mockRemoveWatchlistTvShow;
  late MockGetWatchListTvShowStatus mockGetWatchListTvShowStatus;

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

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    mockSaveWatchlistTvShow = MockSaveWatchlistTvShow();
    mockRemoveWatchlistTvShow = MockRemoveWatchlistTvShow();
    mockGetWatchListTvShowStatus = MockGetWatchListTvShowStatus();

    when(mockGetTvShowDetail.execute(any))
        .thenAnswer((_) async => Right(testTvShowDetail));

    when(mockGetTvShowRecommendations.execute(any))
        .thenAnswer((_) async => Right(tTvShowList));

    when(mockGetWatchListTvShowStatus.execute(0))
        .thenAnswer((_) async => false);

    when(mockGetWatchListTvShowStatus.execute(1))
        .thenAnswer((_) async => false);

    when(mockSaveWatchlistTvShow.execute(testTvShowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist Tv Show'));

    when(mockRemoveWatchlistTvShow.execute(testTvShowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist Tv Show'));
  });

  testWidgets('TvShowList displays list of tv shows correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/detail-tvShow': (context) => MultiProvider(
                providers: [
                  BlocProvider<TvShowDetailBloc>(
                    create: (_) => TvShowDetailBloc(mockGetTvShowDetail),
                  ),
                  BlocProvider<TvShowRecommendationBloc>(
                    create: (_) =>
                        TvShowRecommendationBloc(mockGetTvShowRecommendations),
                  ),
                  BlocProvider<TvShowCrudBloc>(
                    create: (_) => TvShowCrudBloc(
                      saveWatchlistTvShow: mockSaveWatchlistTvShow,
                      removeWatchlistTvShow: mockRemoveWatchlistTvShow,
                      getWatchListTvShowStatus: mockGetWatchListTvShowStatus,
                    ),
                  ),
                ],
                child: TvShowDetailPage(id: tTvShowList[0].id),
              ),
        },
        home: Scaffold(
          body: TvShowList(tTvShowList),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ClipRRect), findsNWidgets(tTvShowList.length));
    expect(find.byType(CachedNetworkImage), findsNWidgets(tTvShowList.length));

    await tester.tap(find.byType(InkWell).first);
    await tester.pump(Duration(seconds: 10)); // Pump once before settling
  });
}
