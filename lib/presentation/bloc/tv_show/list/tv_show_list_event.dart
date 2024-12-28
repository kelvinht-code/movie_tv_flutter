part of 'tv_show_list_bloc.dart';

abstract class TvShowListEvent {}

class FetchAiringTodayTvShows extends TvShowListEvent {}

class FetchOnTheAirTvShows extends TvShowListEvent {}

class FetchPopularTvShows extends TvShowListEvent {}

class FetchTopRatedTvShows extends TvShowListEvent {}
