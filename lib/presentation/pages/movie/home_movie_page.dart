import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/home/home_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/list/tv_show_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/movie_page_widget.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/search_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/search_tv_show_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_page_widget.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/watchlist_tv_shows_page.dart';

import '../about_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  HomeMoviePageState createState() => HomeMoviePageState();
}

class HomeMoviePageState extends State<HomeMoviePage> {
  //int indexTab = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingMovieBloc>().add(FetchNowPlayingMovies());
        context.read<PopularMovieBloc>().add(FetchPopularMovies());
        context.read<TopRatedMovieBloc>().add(FetchTopRatedMovies());
      }
    });
    Future.microtask(() {
      if (mounted) {
        context.read<AiringTodayTvShowBloc>().add(FetchAiringTodayTvShows());
        context.read<OnTheAirTvShowBloc>().add(FetchOnTheAirTvShows());
        context.read<PopularTvShowBloc>().add(FetchPopularTvShows());
        context.read<TopRatedTvShowBloc>().add(FetchTopRatedTvShows());
      }
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
                context.read<HomeBloc>().add(ChangeTabEvent(0));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                context.read<HomeBloc>().add(ChangeTabEvent(1));
                Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Shows'),
              onTap: () {
                context.read<HomeBloc>().add(ChangeTabEvent(2));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.watch_later),
              title: Text('Watchlist TV Show'),
              onTap: () {
                context.read<HomeBloc>().add(ChangeTabEvent(3));
                Navigator.pushNamed(context, WatchlistTvShowsPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                context.read<HomeBloc>().add(ChangeTabEvent(4));
                Navigator.pushNamed(context, AboutPage.routeName);
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
              /*if (indexTab == 1) {
                // FirebaseCrashlytics.instance.crash(); - Test for Crash
                Navigator.pushNamed(context, SearchPage.routeName);
              } else if (indexTab == 3) {
                // FirebaseCrashlytics.instance.crash(); - Test for Crash
                Navigator.pushNamed(context, SearchTvShowPage.routeName);
              }*/
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              print('Ini value home initial ----- ${state.currentTab}');
              if (state.currentTab == 0) {
                return MoviePageWidget();
              } else if (state.currentTab == 2) {
                return TvShowPageWidget();
              }
              /*if (state is HomeInitial) {
                print('Ini jalan home initial');
                //context.read<HomeBloc>().add(ChangeTab(tabIndex: 0));
                return MoviePageWidget();
              }
              if (state is HomeTabChanged) {
                // Logic ini tidak jalan
                print("Ini Jalan Home Page --- ${state.tabIndex}");
                if (state.tabIndex == 0) {
                  return MoviePageWidget();
                } else if  (state.tabIndex == 2) {
                  return TvShowPageWidget();
                }
              }*/
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
