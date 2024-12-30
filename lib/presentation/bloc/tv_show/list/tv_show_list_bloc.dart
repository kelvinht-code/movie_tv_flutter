import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_airing_today.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_on_the_air.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_popular.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_top_rated.dart';

part 'tv_show_list_event.dart';
part 'tv_show_list_state.dart';

class AiringTodayTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetAiringTodayTvShow getAiringTodayTvShow;

  AiringTodayTvShowBloc(this.getAiringTodayTvShow) : super(TvShowListEmpty()) {
    on<FetchAiringTodayTvShows>((event, emit) async {
      emit(TvShowListLoading());
      final result = await getAiringTodayTvShow.execute();
      result.fold(
        (failure) => emit(TvShowListError(failure.message)),
        (tvShows) => emit(TvShowListHasData(tvShows)),
      );
    });
  }
}

class OnTheAirTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetOnTheAirTvShow getOnTheAirTvShow;

  OnTheAirTvShowBloc(this.getOnTheAirTvShow) : super(TvShowListEmpty()) {
    on<FetchOnTheAirTvShows>((event, emit) async {
      emit(TvShowListLoading());
      final result = await getOnTheAirTvShow.execute();
      result.fold(
        (failure) => emit(TvShowListError(failure.message)),
        (tvShows) => emit(TvShowListHasData(tvShows)),
      );
    });
  }
}

class PopularTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetPopularTvShow getPopularTvShow;

  PopularTvShowBloc(this.getPopularTvShow) : super(TvShowListEmpty()) {
    on<FetchPopularTvShows>((event, emit) async {
      emit(TvShowListLoading());
      final result = await getPopularTvShow.execute();
      result.fold(
        (failure) => emit(TvShowListError(failure.message)),
        (tvShows) => emit(TvShowListHasData(tvShows)),
      );
    });
  }
}

class TopRatedTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetTopRatedTvShow getTopRatedTvShow;

  TopRatedTvShowBloc(this.getTopRatedTvShow) : super(TvShowListEmpty()) {
    on<FetchTopRatedTvShows>((event, emit) async {
      emit(TvShowListLoading());
      final result = await getTopRatedTvShow.execute();
      result.fold(
        (failure) => emit(TvShowListError(failure.message)),
        (tvShows) => emit(TvShowListHasData(tvShows)),
      );
    });
  }
}
