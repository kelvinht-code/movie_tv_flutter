import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/movie/movie_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/movie/get_movie_detail.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await getMovieDetail.execute(event.id);
      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (detail) => emit(MovieDetailHasData(detail)),
      );
    });
  }
}
