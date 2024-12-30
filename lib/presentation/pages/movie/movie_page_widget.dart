import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/movie/top_rated_movies_page.dart';

import '../../../common/constants.dart';
import 'popular_movies_page.dart';
import 'movie_list_widget.dart';

class MoviePageWidget extends StatelessWidget {
  const MoviePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Now Playing',
          style: kHeading6,
        ),
        BlocBuilder<NowPlayingMovieBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieListHasData) {
              return MovieList(state.result);
            } else if (state is MovieListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
        _buildSubHeading(
          title: 'Popular',
          onTap: () =>
              Navigator.pushNamed(context, PopularMoviesPage.routeName),
        ),
        BlocBuilder<PopularMovieBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieListHasData) {
              return MovieList(state.result);
            } else if (state is MovieListError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
        _buildSubHeading(
          title: 'Top Rated',
          onTap: () =>
              Navigator.pushNamed(context, TopRatedMoviesPage.routeName),
        ),
        BlocBuilder<TopRatedMovieBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieListHasData) {
              return MovieList(state.result);
            } else if (state is MovieListError) {
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
