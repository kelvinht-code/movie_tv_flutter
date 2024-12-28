import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show_detail.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/crud/tv_show_crud_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/recommendation/tv_show_recommendation_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_detail_page.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_episodes_page.dart';

import '../../../common/constants.dart';
import '../../../domain/entities/tv_show/genre_tv_show.dart';
import '../../../domain/entities/tv_show/tv_show_season.dart';

class TvShowDetailBodyPage extends StatefulWidget {
  final TvShowDetail tvShow;

  const TvShowDetailBodyPage({
    super.key,
    required this.tvShow,
  });

  @override
  State<TvShowDetailBodyPage> createState() => _TvShowDetailBodyPageState();
}

class _TvShowDetailBodyPageState extends State<TvShowDetailBodyPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowCrudBloc>().add(CheckIsWatchlist(widget.tvShow.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        (widget.tvShow.posterPath != '')
            ? CachedNetworkImage(
                key: ValueKey('ImageTvShowDetail'),
                imageUrl: '$BASE_IMAGE_URL${widget.tvShow.posterPath}',
                width: screenWidth,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Icon(
                Icons.broken_image,
                size: screenWidth,
              ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return _btnActionWatchlistTvShow(scrollController, context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _btnActionWatchlistTvShow(
      ScrollController scrollController, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kRichBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.tvShow.name, style: kHeading5),
                  _addOrRemoveWatchlist(widget.tvShow),
                  Text(_showGenres(widget.tvShow.genres)),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.tvShow.voteAverage / 2,
                        itemCount: 5,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: kMikadoYellow,
                        ),
                        itemSize: 24,
                      ),
                      Text('${widget.tvShow.voteAverage}')
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Overview', style: kHeading6),
                  Text(widget.tvShow.overview),
                  SizedBox(height: 16),
                  Text('Recommendations', style: kHeading6),
                  _recommendationTvShowWidget(),
                  SizedBox(height: 16),
                  Text('All Seasons and Episodes', style: kHeading6),
                  _allSeasons(widget.tvShow.seasons),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              height: 4,
              width: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addOrRemoveWatchlist(TvShowDetail tvShow) {
    return BlocListener<TvShowCrudBloc, TvShowCrudState>(
      listener: (context, state) {
        if (state is TvShowCrudSuccess) {
          print('Success Flow');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is TvShowCrudFailure) {
          print('Failed Flow');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<TvShowCrudBloc, TvShowCrudState>(
        builder: (context, state) {
          bool isInWatchlist = false;
          if (state is TvShowCrudStatus) {
            isInWatchlist = state.isInWatchlist;
          }
          print('isInWatchlist: $isInWatchlist');
          return Column(
            children: [
              FilledButton(
                onPressed: () async {
                  final tvCrudBloc = context.read<TvShowCrudBloc>();
                  if (isInWatchlist) {
                    tvCrudBloc.add(RemoveFromWatchlist(tvShow));
                  } else {
                    tvCrudBloc.add(AddToWatchlist(tvShow));
                  }
                  tvCrudBloc.add(CheckIsWatchlist(tvShow.id));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isInWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                    Text('Watchlist'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _recommendationTvShowWidget() {
    return BlocBuilder<TvShowRecommendationBloc, TvShowRecommendationState>(
      builder: (context, state) {
        if (state is TvShowRecommendationLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TvShowRecommendationHasData) {
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                final tvShow = state.result[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TvShowDetailPage.ROUTE_NAME,
                        arguments: tvShow.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: (tvShow.posterPath != null ||
                          tvShow.posterPath != '')
                          ? CachedNetworkImage(
                        key: ValueKey('ImageTvShowDetail'),
                        imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      )
                          : Icon(Icons.broken_image),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is TvShowRecommendationError) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _allSeasons(List<TvShowSeason> listSeasons) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listSeasons.length,
        itemBuilder: (context, index) {
          final season = listSeasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvShowEpisodesPage.ROUTE_NAME,
                  arguments: {
                    'id': widget.tvShow.id,
                    'seasons': season.seasonNumber,
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: (season.posterPath.isNotEmpty)
                    ? CachedNetworkImage(
                  key: ValueKey('ImageTvShowDetail'),
                  imageUrl: '$BASE_IMAGE_URL${widget.tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
                    : Icon(Icons.broken_image),
              ),
            ),
          );
        },
      ),
    );
  }

  String _showGenres(List<GenreTvShow> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
