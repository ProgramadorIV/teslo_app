import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        '/auth/check-status',
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            message: e.response?.data['message'] ?? 'Invalid token');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Please check internet connection');
      }
      throw Exception();
    } catch (_) {
      throw Exception('Something really bad just happened');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Wrong credentials',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Connection timeout',
        );
      }
      throw CustomError(
        message: 'Something very bad just happened',
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullname) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'fullName': fullname,
        },
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Wrong credentials',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Connection timeout',
        );
      }
      throw CustomError(
        message: 'Something very bad just happened',
      );
    } catch (e) {
      throw Exception();
    }
  }
}
