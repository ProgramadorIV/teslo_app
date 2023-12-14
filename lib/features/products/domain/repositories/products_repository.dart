import '../entities/products.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProductByPage({int limit = 10, offset = 0});
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProductByParam(String query);
  Future<Product> createUpdateProduct(Map<String, dynamic> productRaw);
}
