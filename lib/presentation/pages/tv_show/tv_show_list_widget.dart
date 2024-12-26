import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_tv_level_maximum/domain/entities/tv_show/tv_show.dart';
import 'package:movie_tv_level_maximum/presentation/pages/tv_show/tv_show_detail_page.dart';

import '../../../common/constants.dart';

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShows;

  const TvShowList(this.tvShows, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvShowDetailPage.ROUTE_NAME,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: (tvShow.posterPath != '')
                    ? CachedNetworkImage(
                        imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
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
        itemCount: tvShows.length,
      ),
    );
  }
}
