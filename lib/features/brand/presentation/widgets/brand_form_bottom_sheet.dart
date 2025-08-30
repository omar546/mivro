import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../data/models/brand_model.dart';

class BrandFormBottomSheet extends StatefulWidget {
  final Brand? brand;
  final Future<void> Function(Brand) onSave;

  const BrandFormBottomSheet({super.key, this.brand, required this.onSave});

  @override
  State<BrandFormBottomSheet> createState() => _BrandFormBottomSheetState();
}

class _BrandFormBottomSheetState extends State<BrandFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _logoController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;
  late final TextEditingController _facebookController;
  late final TextEditingController _instagramController;
  late final TextEditingController _twitterController;
  late final TextEditingController _descriptionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final brand = widget.brand;
    _nameController = TextEditingController(text: brand?.name ?? '');
    _logoController = TextEditingController(text: brand?.logo ?? '');
    _emailController = TextEditingController(text: brand?.email ?? '');
    _phoneController = TextEditingController(text: brand?.phone ?? '');
    _websiteController = TextEditingController(text: brand?.website ?? '');
    _facebookController = TextEditingController(text: brand?.facebook ?? '');
    _instagramController = TextEditingController(text: brand?.instagram ?? '');
    _twitterController = TextEditingController(text: brand?.twitter ?? '');
    _descriptionController = TextEditingController(
      text: brand?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _logoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            widget.brand == null ? 'Add Brand Info' : 'Edit Brand Info',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Brand Name (Required)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Brand Name *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.business),
                      ),
                      validator:
                          (value) =>
                              value?.isEmpty == true
                                  ? 'Brand name is required'
                                  : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Logo URL
                  TextFormField(
                    controller: _logoController,
                    decoration: InputDecoration(
                      labelText: 'Logo URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.image),
                      hintText: 'https://example.com/logo.png',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Information Section
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _websiteController,
                    decoration: InputDecoration(
                      labelText: 'Website',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.language),
                      hintText: 'https://yourwebsite.com',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 20),

                  // Social Media Section
                  Text(
                    'Social Media',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _facebookController,
                    decoration: InputDecoration(
                      labelText: 'Facebook',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.facebook),
                      hintText: '@yourbrand or facebook.com/yourbrand',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _instagramController,
                    decoration: InputDecoration(
                      labelText: 'Instagram',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.camera_alt),
                      hintText: '@yourbrand',
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _twitterController,
                    decoration: InputDecoration(
                      labelText: 'Twitter/X',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.flutter_dash),
                      hintText: '@yourbrand',
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveBrand,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveBrand() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final brand = Brand(
        name: _nameController.text.trim(),
        logo: _logoController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        website: _websiteController.text.trim(),
        facebook: _facebookController.text.trim(),
        instagram: _instagramController.text.trim(),
        twitter: _twitterController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      try {
        await widget.onSave(brand);
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Brand info ${widget.brand == null ? 'added' : 'updated'} successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving brand info: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
