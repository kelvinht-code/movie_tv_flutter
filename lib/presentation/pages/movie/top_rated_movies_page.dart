import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:provider/provider.dart';

import '../../provider/movie/top_rated_movies_notifier.dart';
import '../../widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedMovieBloc>().add(FetchTopRatedMovies()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieListHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is MovieListError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
