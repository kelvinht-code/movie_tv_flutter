import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/list/tv_show_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/on_the_air_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/popular_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/top_rated_tv_shows_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_list_widget.dart';

import '../../../common/constants.dart';

class TvShowPageWidget extends StatelessWidget {
  const TvShowPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Airing Today',
          style: kHeading6,
        ),
        BlocBuilder<AiringTodayTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvShowListHasData) {
              return TvShowList(state.result);
            } else if (state is TvShowListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
        _buildSubHeading(
          title: 'On The Air',
          onTap: () =>
              Navigator.pushNamed(context, OnTheAirTvShowsPage.ROUTE_NAME),
        ),
        BlocBuilder<OnTheAirTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvShowListHasData) {
              return TvShowList(state.result);
            } else if (state is TvShowListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
        _buildSubHeading(
          title: 'Popular',
          onTap: () =>
              Navigator.pushNamed(context, PopularTvShowsPage.ROUTE_NAME),
        ),
        BlocBuilder<PopularTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvShowListHasData) {
              return TvShowList(state.result);
            } else if (state is TvShowListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
        _buildSubHeading(
          title: 'Top Rated',
          onTap: () =>
              Navigator.pushNamed(context, TopRatedTvShowsPage.ROUTE_NAME),
        ),
        BlocBuilder<TopRatedTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvShowListHasData) {
              return TvShowList(state.result);
            } else if (state is TvShowListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ],
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
