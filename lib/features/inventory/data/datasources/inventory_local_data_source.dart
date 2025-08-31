import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class InventoryLocalDataSource {
  final Box<ProductModel> productBox;
  final Box<CategoryModel> categoryBox;

  InventoryLocalDataSource(this.productBox, this.categoryBox);

  Future<void> addProduct(ProductModel product) async {
    await productBox.put(product.id, product);
  }

  Future<void> deleteProduct(String id) async {
    await productBox.delete(id);
  }

  Future<void> updateProduct(ProductModel product) async {
    await productBox.put(product.id, product);
  }

  Future<List<ProductModel>> getProducts() async {
    return productBox.values.toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await categoryBox.put(category.name, category);
  }

  Future<void> deleteCategory(String name) async {
    const String fallbackCategory = "Uncategorized";

    // Ensure fallback category exists
    if (!categoryBox.containsKey(fallbackCategory)) {
      await categoryBox.put(
        fallbackCategory,
        CategoryModel(name: fallbackCategory),
      );
    }

    // Update products that used this category
    for (var product in productBox.values) {
      if (product.category == name) {
        product.category = fallbackCategory;
        await product.save(); // quicker than re-put
      }
    }

    // Delete the category
    await categoryBox.delete(name);
  }

  Future<List<CategoryModel>> getCategories() async {
    return categoryBox.values.toList();
  }
}
