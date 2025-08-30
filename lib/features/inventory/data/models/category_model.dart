import 'package:hive/hive.dart';
import '../../domain/entities/category.dart';

part 'category_model_adapter.dart';

@HiveType(typeId: 1) // unique from Product's typeId
class CategoryModel extends HiveObject {
  @HiveField(0)
  String name;

  CategoryModel({required this.name});

  // Convert to entity
  Category toEntity() => Category(name: name);

  // Convert from entity
  static CategoryModel fromEntity(Category category) {
    return CategoryModel(name: category.name);
  }
}
