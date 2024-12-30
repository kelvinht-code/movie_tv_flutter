import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/bloc/tv_show/search/search_tv_show_bloc.dart';
import 'package:movie_tv_level_maximum/presentation/widgets/tv_show_card_list.dart';

import '../../../common/constants.dart';

class SearchTvShowPage extends StatelessWidget {
  static const routeName = '/search-tvShow';

  const SearchTvShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search TV Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context
                    .read<SearchTvShowBloc>()
                    .add(OnQueryTvShowChange(query));
              },
              decoration: InputDecoration(
                hintText: 'Search TV Show',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTvShowBloc, SearchTvShowState>(
              builder: (context, state) {
                if (state is SearchTvShowLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvShowHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvShow = result[index];
                        return TvShowCard(tvShow);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTvShowError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
