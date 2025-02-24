import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_sembast_storage/dio_cache_interceptor_sembast_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocary/app/controllers/auth_controller.dart';
import 'package:vocary/core/config.dart';
import 'package:vocary/core/logger.dart';

class Http {
  late final Dio _dio;
  late CacheStore _cacheStore;
  late CacheOptions _defaultCacheOptions;
  static bool _initialized = false;

  static final Http _instance = Http._internal();

  factory Http() {
    return _instance;
  }

  Http._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.apiEndpoint,
        connectTimeout: Duration(seconds: Config.connectTimeout),
        receiveTimeout: Duration(seconds: Config.receiveTimeout),
        headers: {'Accept': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _authInterceptor(), // Attach JWT token
      if (Config.enableLogging) _loggingInterceptor(), // Pretty logger
    ]);
  }

  Future<void> initialize() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _cacheStore = SembastCacheStore(storePath: dir.path);

    _defaultCacheOptions = CacheOptions(
      store: _cacheStore,
      policy: CachePolicy.forceCache,
      maxStale: const Duration(hours: 1) as Duration?,
      hitCacheOnErrorExcept: [
        401,
        403,
        404,
      ], // Use cache when offline (except auth errors)
      priority: CachePriority.high,
    );

    _dio.interceptors.add(DioCacheInterceptor(options: _defaultCacheOptions));

    _initialized = true;
  }

  /// Interceptor to attach JWT token to requests
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthController.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          Log.w('Unauthorized! Token might be expired.');
          // TODO: Implement token refresh logic
        }
        return handler.next(e);
      },
    );
  }

  /// Logging interceptor (for debugging)
  InterceptorsWrapper _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        Log.d('[HTTP REQUEST] ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        Log.i('[HTTP RESPONSE] ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        Log.e('[HTTP ERROR] ${e.response?.statusCode} ${e.message}');
        return handler.next(e);
      },
    );
  }

  /// Generic GET request with custom TTL
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Duration? ttl,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheOptions =
          _defaultCacheOptions
              .copyWith(
                policy:
                    forceRefresh
                        ? CachePolicy.refreshForceCache
                        : CachePolicy.request,
                maxStale:
                    ttl != null ? Nullable(ttl) : Nullable(Duration(hours: 1)),
              )
              .toOptions();

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: cacheOptions,
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Generic POST request with status handling
  Future<Map<String, dynamic>> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Generic PUT request with status handling
  Future<Map<String, dynamic>> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Generic DELETE request with status handling
  Future<Map<String, dynamic>> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handle HTTP response inside Http
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 304) {
      return {
        'success': true,
        'data': response.data, // ✅ Send only processed data
      };
    } else {
      return {
        'success': false,
        'error': 'Unexpected response: ${response.statusCode}',
      };
    }
  }

  /// Handle errors globally inside Http
  Map<String, dynamic> _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return {
          'success': false,
          'error': 'Unauthorized (401). Please login again.',
        };
      }
      if (error.response?.statusCode == 403) {
        return {'success': false, 'error': 'Forbidden (403). Access denied.'};
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return {
          'success': false,
          'error': 'Network timeout. Please try again.',
        };
      }
      return {'success': false, 'error': 'Network error: ${error.message}'};
    }

    return {'success': false, 'error': 'Unexpected error occurred.'};
  }

  /// Clear cache manually
  Future<void> clearCache() async {
    await _cacheStore.clean();
  }

  /// Expose Dio instance for custom API calls
  Dio get client => _dio;
}
