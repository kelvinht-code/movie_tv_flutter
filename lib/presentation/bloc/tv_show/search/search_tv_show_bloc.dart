import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/search_tv_shows.dart';
import 'package:rxdart/rxdart.dart';

part 'search_tv_show_event.dart';
part 'search_tv_show_state.dart';

class SearchTvShowBloc extends Bloc<SearchTvShowEvent, SearchTvShowState> {
  final SearchTvShows _searchTvShows;

  SearchTvShowBloc(this._searchTvShows) : super(SearchTvShowEmpty()) {
    on<OnQueryTvShowChange>(
      (event, emit) async {
        final query = event.query;

        emit(SearchTvShowLoading());
        final result = await _searchTvShows.execute(query);

        result.fold(
          (failure) {
            emit(SearchTvShowError(failure.message));
          },
          (data) {
            emit(SearchTvShowHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
