import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/detail/tv_show_detail_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/recommendation/tv_show_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_detail_body_page.dart';

class TvShowDetailPage extends StatefulWidget {
  static const routeName = '/detail-tvShow';
  final int id;

  const TvShowDetailPage({super.key, required this.id});

  @override
  State<TvShowDetailPage> createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowDetailBloc>().add(FetchTvShowDetail(widget.id));
      context
          .read<TvShowRecommendationBloc>()
          .add(FetchTvShowRecommendation(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TvShowDetailHasData) {
            final tvShow = state.result;
            return SafeArea(
              child: TvShowDetailBodyPage(tvShow: tvShow),
            );
          } else if (state is TvShowDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
