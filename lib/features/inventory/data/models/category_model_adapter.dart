part of 'category_model.dart';

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 1;

  @override
  CategoryModel read(BinaryReader reader) {
    return CategoryModel(name: reader.read());
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer.write(obj.name);
  }
}
