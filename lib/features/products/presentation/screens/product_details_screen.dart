import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      productId == 'new'
          ? const SnackBar(content: Text('Created succesfully!'))
          : const SnackBar(content: Text('Updated succesfully!')),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final productState = ref.watch(productProvider(productId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${productId == 'new' ? 'New' : 'Edit'} product'),
          actions: [
            IconButton(
              onPressed: () async {
                final imgPath = await CameraGalleryServiceImpl().selectPhoto();
                if (imgPath == null) return;
                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .onImagesChange(imgPath);
              },
              icon: const Icon(Icons.photo_library_outlined),
            ),
            IconButton(
              onPressed: () async {
                final imgPath = await CameraGalleryServiceImpl().takePhoto();
                if (imgPath == null) return;
                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .onImagesChange(imgPath);
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        body: productState.isLoading
            ? const FullScreenLoader()
            : _ProductView(product: productState.product!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (productState.product == null) return;

            ref
                .read(productFormProvider(productState.product!).notifier)
                .onFormSubmit()
                .then((value) {
              if (!value) return;
              showSnackbar(context);
            });
          },
          child: const Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, ref) {
    final productForm = ref.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productForm.images),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            productForm.title.value,
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('General info'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Name',
            initialValue: productForm.title.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onTitleChange,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onSlugChange,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Price',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onPriceChange(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChangeCallBack:
                ref.read(productFormProvider(product).notifier).onSizesChange,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productForm.gender,
            onGenderChangeCallback:
                ref.read(productFormProvider(product).notifier).onGenderChange,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Stock',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: product.stock.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onStockChange(int.tryParse(value) ?? -1),
            errorMessage: productForm.stock.errorMessage,
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Description',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChange,
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separated with commas)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged:
                ref.read(productFormProvider(product).notifier).onTagsChange,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends ConsumerWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final void Function(List<String> selectedSizes) onSizesChangeCallBack;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChangeCallBack,
  });

  @override
  Widget build(BuildContext context, ref) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChangeCallBack(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final void Function(String gender) onGenderChangeCallback;
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector({
    required this.selectedGender,
    required this.onGenderChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          onGenderChangeCallback(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
        ),
      );
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.map((image) {
        late ImageProvider imageProvider;

        if (image.startsWith('http')) {
          imageProvider = NetworkImage(image);
        } else {
          imageProvider = FileImage(File(image));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FadeInImage(
              fit: BoxFit.cover,
              image: imageProvider,
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
            ),
          ),
        );
      }).toList(),
    );
  }
}
