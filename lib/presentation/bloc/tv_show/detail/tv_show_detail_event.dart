part of 'tv_show_detail_bloc.dart';

abstract class TvShowDetailEvent {}

class FetchTvShowDetail extends TvShowDetailEvent {
  final int id;

  FetchTvShowDetail(this.id);
}
