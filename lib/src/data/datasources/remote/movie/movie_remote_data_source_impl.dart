import '../../../../core/constants/url_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../models/movie_credit/movie_credit_model.dart';
import '../../../models/movie_listings/movie_listings_model.dart';
import 'movie_remote_data_source.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient _dioClient;

  const MovieRemoteDataSourceImpl(this._dioClient);

  @override
  Future<MovieListingsModel> getPopularMovies({required int page}) async {
    try {
      final response = await _dioClient
          .get(UrlConstants.popularMovies, queryParameters: {'page': page});

      final model =
          MovieListingsModel.fromJson(response.data as Map<String, dynamic>);

      return model;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MovieListingsModel> getTopRatedMovies({required int page}) async {
    try {
      final response = await _dioClient
          .get(UrlConstants.topRatedMovies, queryParameters: {'page': page});

      final model =
          MovieListingsModel.fromJson(response.data as Map<String, dynamic>);

      return model;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MovieCreditModel> getMovieCredits({required int movieId}) async {
    try {
      final response = await _dioClient.get(UrlConstants.movieCredits
          .replaceAll('{movie_id}', movieId.toString()));

      final model =
          MovieCreditModel.fromJson(response.data as Map<String, dynamic>);

      return model;
    } catch (_) {
      rethrow;
    }
  }
}
