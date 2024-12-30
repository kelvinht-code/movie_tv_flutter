import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/movie/list/movie_list_bloc.dart';

import '../../widgets/movie_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  PopularMoviesPageState createState() => PopularMoviesPageState();
}

class PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularMovieBloc>().add(FetchPopularMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, MovieListState>(
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
