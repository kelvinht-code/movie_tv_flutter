import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_tv_level_maximum/data/models/tv_show/tv_show_detail_response.dart';
import 'package:movie_tv_level_maximum/data/models/tv_show/tv_show_episodes_response.dart';
import 'package:movie_tv_level_maximum/data/models/tv_show/tv_show_model.dart';
import 'package:movie_tv_level_maximum/data/models/tv_show/tv_show_response.dart';

import '../../../common/exception.dart';

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getAiringTodayTvShow();
  Future<List<TvShowModel>> getOnTheAirTvShow();
  Future<List<TvShowModel>> getPopularTvShow();
  Future<List<TvShowModel>> getTopRatedTvShow();
  Future<TvShowDetailResponse> getTvShowDetail(int id);
  Future<List<TvShowModel>> searchTvShow(String query);
  Future<List<TvShowModel>> getTvShowRecommendation(int id);
  Future<TvShowEpisodeResponse> getAllEpisodes(int id, int season);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvShowRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<TvShowModel>> getAiringTodayTvShow() async {
    final url = Uri.parse('$baseUrl/tv/airing_today?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getOnTheAirTvShow() async {
    final url = Uri.parse('$baseUrl/tv/on_the_air?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getPopularTvShow() async {
    final url = Uri.parse('$baseUrl/tv/popular?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShow() async {
    final url = Uri.parse('$baseUrl/tv/top_rated?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowDetailResponse> getTvShowDetail(int id) async {
    final url = Uri.parse('$baseUrl/tv/$id?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> searchTvShow(String query) async {
    final url = Uri.parse('$baseUrl/search/tv?$apiKey&query=$query');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTvShowRecommendation(int id) async {
    final url = Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowResponse.fromJson(json.decode(response.body)).tvShowList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowEpisodeResponse> getAllEpisodes(int id, int season) async {
    final url = Uri.parse('$baseUrl/tv/$id/season/$season?$apiKey');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return TvShowEpisodeResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
