import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Şimdilik Base URL'i localhost veya bir test sunucusu olarak belirliyoruz.
// Gerçek API bilgisi geldiğinde burası güncellenecektir.
const String baseUrl = 'http://localhost:8000/api/v1/';

// API İsteklerini yönetecek olan servis sınıfımız.
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // Örnek bir GET isteği metodu.
  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      // Hata yönetimi (Loglama, kullanıcıya mesaj gösterme vs. eklenebilir)
      throw Exception('API Hatası: \${e.message}');
    }
  }

  // Örnek bir POST isteği metodu.
  Future<Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('API Hatası: \${e.message}');
    }
  }
}

// Dio instance'ı için bir provider.
// Timeout, BaseURL ve Headers gibi temel ayarları burada yapılandırıyoruz.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        // Gerekirse Authorization token buraya eklenecek:
        // 'Authorization': 'Bearer YOUR_TOKEN',
      },
    ),
  );
});

// ApiService için bir provider, böylece uygulamanın her yerinden erişebiliriz.
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
