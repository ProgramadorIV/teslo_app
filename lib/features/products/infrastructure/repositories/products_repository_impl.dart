import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource productsDatasource;

  ProductsRepositoryImpl(this.productsDatasource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productRaw) {
    return productsDatasource.createUpdateProduct(productRaw);
  }

  @override
  Future<Product> getProductById(String id) {
    return productsDatasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductByPage({int limit = 10, offset = 0}) {
    return productsDatasource.getProductByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductByParam(String query) {
    return productsDatasource.searchProductByParam(query);
  }
}
