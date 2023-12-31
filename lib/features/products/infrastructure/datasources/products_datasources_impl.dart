import 'package:dio/dio.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../errors/product_errors.dart';
import '../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ));

  Future<String> _uploadFile(String path) async {
    try {
      final String filename = path.split('/').last;

      final FormData data = FormData.fromMap(
          {'file': MultipartFile.fromFileSync(path, filename: filename)});

      final response = await dio.post('/files/product', data: data);

      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadImages(List<String> photos) async {
    final newPhotos = photos.where((element) => element.contains('/')).toList();
    final oldImages =
        photos.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadedImages =
        newPhotos.map(_uploadFile).toList();

    final newImages = await Future.wait(uploadedImages);

    return [...oldImages, ...newImages];
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productRaw) async {
    try {
      final String? productId = productRaw['id'];
      final String method = productId == null ? 'POST' : 'PATCH';
      final String url =
          productId == null ? '/products' : '/products/$productId';

      productRaw.remove('id');
      productRaw['images'] = await _uploadImages(productRaw['images']);

      final response = await dio.request(url,
          data: productRaw,
          options: Options(
            method: method,
          ));

      final product = ProductMapper.jsonToProduct(response.data);
      return product;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      return ProductMapper.jsonToProduct(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductByPage({int limit = 10, offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToProduct(product));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByParam(String query) {
    // TODO: implement searchProductByParam
    throw UnimplementedError();
  }
}
