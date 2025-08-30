import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category.dart';
import '../cubit/inventory_cubit.dart';

class CategoryManagerBottomSheet extends StatefulWidget {
  const CategoryManagerBottomSheet({super.key});

  @override
  State<CategoryManagerBottomSheet> createState() =>
      _CategoryManagerBottomSheetState();
}

class _CategoryManagerBottomSheetState
    extends State<CategoryManagerBottomSheet> {
  final TextEditingController _newCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().loadCategories();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        final categories = state.categories;

        return Container(
          height: MediaQuery.sizeOf(context).height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manage Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Add new category
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newCategoryController,
                      decoration: InputDecoration(
                        labelText: 'New Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final name = _newCategoryController.text.trim();
                      if (name.isNotEmpty) {
                        context.read<InventoryCubit>().addCategory(
                          Category(name: name),
                        );
                        _newCategoryController.clear();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.label),
                        title: Text(cat.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<InventoryCubit>().deleteCategory(
                              cat.name,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        );
      },
    );
  }
}
