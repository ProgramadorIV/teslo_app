import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  final createUpdateProduct =
      ref.watch(productsProvider.notifier).createUpdateProduct;

  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpdateProduct,
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(
          ProductFormState(
            id: product.id,
            title: Title.dirty(product.title),
            slug: Slug.dirty(product.slug),
            price: Price.dirty(product.price),
            sizes: product.sizes,
            gender: product.gender,
            stock: Stock.dirty(product.stock),
            description: product.description,
            tags: product.tags.join(', '),
            images: product.images,
          ),
        );

  final Future<bool> Function(Map<String, dynamic> productRaw)?
      onSubmitCallback;

  void onImagesChange(String imgPath) {
    state = state.copyWith(images: [...state.images, imgPath]);
  }

  void onTitleChange(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onSlugChange(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isValid: Formz.validate([
        Slug.dirty(value),
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onPriceChange(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isValid: Formz.validate([
        Price.dirty(value),
        Slug.dirty(state.slug.value),
        Title.dirty(state.title.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onStockChange(int value) {
    state = state.copyWith(
      stock: Stock.dirty(value),
      isValid: Formz.validate([
        Stock.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Title.dirty(state.title.value),
      ]),
    );
  }

  void onSizesChange(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onDescriptionChange(String description) {
    state = state.copyWith(description: description);
  }

  void onGenderChange(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onTagsChange(String tags) {
    state = state.copyWith(tags: tags);
  }

  _validateFields() {
    state = state.copyWith(
      isValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  Future<bool> onFormSubmit() async {
    _validateFields();

    if (!state.isValid) return false;
    if (onSubmitCallback == null) return false;

    final productRaw = {
      'id': state.id == 'new' ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'slug': state.slug.value,
      'gender': state.gender,
      'stock': state.stock.value,
      'sizes': state.sizes,
      'description': state.description,
      'tags': state.tags.split(', '),
      'images': state.images
          .map((e) => e.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList()
    };

    try {
      return await onSubmitCallback!(productRaw);
    } catch (_) {
      return false;
    }
  }
}

class ProductFormState {
  final bool isValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.stock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isValid: isValid ?? this.isValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        stock: stock ?? this.stock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
