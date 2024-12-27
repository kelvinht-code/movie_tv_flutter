import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie_tv_level_maximum/data/data_sources/tv_show/tv_show_local_data_source.dart';
import 'package:movie_tv_level_maximum/data/data_sources/tv_show/tv_show_remote_data_source.dart';
import 'package:movie_tv_level_maximum/data/repositories/tv_show_repository_impl.dart';
import 'package:movie_tv_level_maximum/domain/repositories/tv_show_repository.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_airing_today.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_episodes.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_on_the_air.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_popular.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_recommendations.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_top_rated.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_show_status.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_watchlist_tv_shows.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/remove_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/save_watchlist_tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/search_tv_shows.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/search/search_movie_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/list/tv_show_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/search/search_tv_show_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/on_the_air_tv_shows_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/popular_tv_shows_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/top_rated_tv_shows_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/tv_show_detail_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/tv_show_episodes_notifier.dart';
import 'package:movie_tv_level_maximum/presentation/provider/tv_show/watchlist_tv_show_notifier.dart';

import 'data/data_sources/db/database_helper.dart';
import 'data/data_sources/movie/movie_local_data_source.dart';
import 'data/data_sources/movie/movie_remote_data_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/repositories/movie_repository.dart';
import 'domain/use_cases/movie/get_movie_detail.dart';
import 'domain/use_cases/movie/get_movie_recommendations.dart';
import 'domain/use_cases/movie/get_now_playing_movies.dart';
import 'domain/use_cases/movie/get_popular_movies.dart';
import 'domain/use_cases/movie/get_top_rated_movies.dart';
import 'domain/use_cases/movie/get_watchlist_movies.dart';
import 'domain/use_cases/movie/get_watchlist_status.dart';
import 'domain/use_cases/movie/remove_watchlist.dart';
import 'domain/use_cases/movie/save_watchlist.dart';
import 'domain/use_cases/movie/search_movies.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => NowPlayingMovieBloc(locator()),
  );
  locator.registerFactory(
    () => PopularMovieBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedMovieBloc(locator()),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchMovieBloc(locator()),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => AiringTodayTvShowBloc(locator()),
  );
  locator.registerFactory(
    () => OnTheAirTvShowBloc(locator()),
  );
  locator.registerFactory(
    () => PopularTvShowBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedTvShowBloc(locator()),
  );
  locator.registerFactory(
    () => OnTheAirTvShowsNotifier(
      getOnTheAirTvShow: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvShowsNotifier(
      getPopularTvShow: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvShowsNotifier(
      getTopRatedTvShow: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowDetailNotifier(
      getTvShowDetail: locator(),
      getTvShowRecommendations: locator(),
      getWatchListTvShowStatus: locator(),
      saveWatchlistTvShow: locator(),
      removeWatchlistTvShow: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchTvShowBloc(locator()),
  );
  locator.registerFactory(
    () => WatchlistTvShowNotifier(
      getWatchlistTvShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowEpisodesNotifier(
      getTvShowEpisodes: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetAiringTodayTvShow(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTvShow(locator()));
  locator.registerLazySingleton(() => GetPopularTvShow(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShow(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvShows(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvShows(locator()));
  locator.registerLazySingleton(() => GetWatchListTvShowStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvShow(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvShow(locator()));
  locator.registerLazySingleton(() => GetTvShowEpisodes(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvShowRemoteDataSource>(
      () => TvShowRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
    () => TvShowLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
