import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/list/tv_show_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_page_widget.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/search_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/search_tv_show_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_page_widget.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/watchlist_tv_shows_page.dart';
import 'package:provider/provider.dart';

import '../about_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  int indexTab = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(FetchNowPlayingMovies());
      context.read<PopularMovieBloc>().add(FetchPopularMovies());
      context.read<TopRatedMovieBloc>().add(FetchTopRatedMovies());
    });
    Future.microtask(() {
      context.read<AiringTodayTvShowBloc>().add(FetchAiringTodayTvShows());
      context.read<OnTheAirTvShowBloc>().add(FetchOnTheAirTvShows());
      context.read<PopularTvShowBloc>().add(FetchPopularTvShows());
      context.read<TopRatedTvShowBloc>().add(FetchTopRatedTvShows());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                setState(() {
                  indexTab = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                setState(() {
                  indexTab = 2;
                });
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Shows'),
              onTap: () {
                setState(() {
                  indexTab = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.watch_later),
              title: Text('Watchlist TV Show'),
              onTap: () {
                setState(() {
                  indexTab = 4;
                });
                Navigator.pushNamed(context, WatchlistTvShowsPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                setState(() {
                  indexTab = 5;
                });
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              if (indexTab == 1) {
                // FirebaseCrashlytics.instance.crash(); - Test for Crash
                Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
              } else if (indexTab == 3) {
                // FirebaseCrashlytics.instance.crash(); - Test for Crash
                Navigator.pushNamed(context, SearchTvShowPage.ROUTE_NAME);
              }
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: indexTab == 1
              ? MoviePageWidget()
              : indexTab == 3
                  ? TvShowPageWidget()
                  : SizedBox(),
        ),
      ),
    );
  }
}
