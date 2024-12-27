import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_detail.dart';
import 'package:movie_tv_level_maximum/domain/use_cases/tv_show/get_tv_show_detail.dart';

part 'tv_show_detail_event.dart';
part 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail getTvShowDetail;

  TvShowDetailBloc(this.getTvShowDetail) : super(TvShowDetailEmpty()) {
    on<FetchTvShowDetail>((event, emit) async {
      emit(TvShowDetailLoading());
      final result = await getTvShowDetail.execute(event.id);
      result.fold(
        (failure) => emit(TvShowDetailError(failure.message)),
        (detail) => emit(TvShowDetailHasData(detail)),
      );
    });
  }
}
