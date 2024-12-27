import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_tv_level_maximum/injection.dart' as di;
import 'package:movie_tv_level_maximum/presentation/bloc/movie/search/search_movie_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/about_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/home_movie_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_detail_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/popular_movies_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/search_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/on_the_air_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/popular_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/search_tv_show_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/top_rated_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_detail_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_episodes_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/watchlist_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/movie_list_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/movie_search_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/on_the_air_tv_shows_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/popular_tv_shows_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/top_rated_tv_shows_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/tv_show_detail_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/tv_show_episodes_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/tv_show_list_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/tv_show_search_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/watchlist_tv_show_notifier.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'common/utils.dart';

void main() {
  di.init();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<OnTheAirTvShowsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvShowsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvShowsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvShowNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvShowEpisodesNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case OnTheAirTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => OnTheAirTvShowsPage());
            case PopularTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvShowsPage());
            case TopRatedTvShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvShowsPage());
            case TvShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            case SearchTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvShowPage());
            case WatchlistTvShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowsPage());
            case TvShowEpisodesPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>?;
              if (args != null) {
                final id = args['id'] as int?;
                final seasons = args['seasons'] as int?;
                if (id != null && seasons != null) {
                  return MaterialPageRoute(
                    builder: (_) => TvShowEpisodesPage(id: id, season: seasons),
                  );
                }
              }
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
          return null;
        },
      ),
    );
  }
}
