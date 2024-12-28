import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:movie_tv_level_maximum/common/ssl_pinning.dart';

import '../../../common/exception.dart';
import '../../models/movie/movie_detail_model.dart';
import '../../models/movie/movie_model.dart';
import '../../models/movie/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    // With SSL Pinning
    final url = Uri.parse('$BASE_URL/movie/now_playing?$API_KEY');
    // IOClient ioClient = await getIOClient;
    // final response = await ioClient.get(url);

    // Without SSL Pinning
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final url = Uri.parse('$BASE_URL/movie/$id?$API_KEY');
    IOClient ioClient = await getIOClient;
    final response = await ioClient.get(url);

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final url = Uri.parse('$BASE_URL/movie/$id/recommendations?$API_KEY');
    IOClient ioClient = await getIOClient;
    final response = await ioClient.get(url);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final url = Uri.parse('$BASE_URL/movie/popular?$API_KEY');
    IOClient ioClient = await getIOClient;
    final response = await ioClient.get(url);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final url = Uri.parse('$BASE_URL/movie/top_rated?$API_KEY');
    IOClient ioClient = await getIOClient;
    final response = await ioClient.get(url);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final url = Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$query');
    IOClient ioClient = await getIOClient;
    final response = await ioClient.get(url);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}
