import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/widgets/tv_show_card_list.dart';

import '../../bloc/tv_show/list/tv_show_list_bloc.dart';

class OnTheAirTvShowsPage extends StatefulWidget {
  static const routeName = '/onTheAir-tvShow';

  const OnTheAirTvShowsPage({super.key});

  @override
  State<OnTheAirTvShowsPage> createState() => _OnTheAirTvShowsPage();
}

class _OnTheAirTvShowsPage extends State<OnTheAirTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<OnTheAirTvShowBloc>().add(FetchOnTheAirTvShows());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On The Air TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvShowListHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.result[index];
                  return TvShowCard(tvShow);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvShowListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
