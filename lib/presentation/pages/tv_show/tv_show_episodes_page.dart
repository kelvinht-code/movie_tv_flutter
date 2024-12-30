import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/episodes/tv_show_episodes_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_episodes_body_page.dart';

class TvShowEpisodesPage extends StatefulWidget {
  static const routeName = '/season-episodes';
  final int id;
  final int season;

  const TvShowEpisodesPage({
    super.key,
    required this.id,
    required this.season,
  });

  @override
  State<TvShowEpisodesPage> createState() => _TvShowEpisodesPageState();
}

class _TvShowEpisodesPageState extends State<TvShowEpisodesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context
            .read<TvShowEpisodesBloc>()
            .add(FetchTvShowEpisodes(widget.id, widget.season));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowEpisodesBloc, TvShowEpisodesState>(
      builder: (context, state) {
        if (state is TvShowEpisodesLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TvShowEpisodesHasData) {
          return SafeArea(
            child: TvShowEpisodesBodyPage(tvShowEpisodes: state.result),
          );
        } else if (state is TvShowEpisodesError) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    );
  }
}
