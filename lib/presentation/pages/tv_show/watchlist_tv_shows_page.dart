import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/watchlist/tv_show_watchlist_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/widgets/tv_show_card_list.dart';

import '../../../common/utils.dart';

class WatchlistTvShowsPage extends StatefulWidget {
  static const routeName = '/watchlist-tvShow';

  const WatchlistTvShowsPage({super.key});

  @override
  State<WatchlistTvShowsPage> createState() => _WatchlistTvShowsPageState();
}

class _WatchlistTvShowsPageState extends State<WatchlistTvShowsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvShowWatchlistBloc>().add(FetchTvShowWatchlist());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<TvShowWatchlistBloc>().add(FetchTvShowWatchlist());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowWatchlistBloc, TvShowWatchlistState>(
          builder: (context, state) {
            if (state is TvShowWatchlistLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TvShowWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.result[index];
                  return TvShowCard(tvShow);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvShowWatchlistError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
