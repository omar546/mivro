import 'package:flutter/material.dart';
import 'package:mivro/core/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

import '../../data/models/brand_model.dart';
import '../widgets/brand_form_bottom_sheet.dart';
import '../widgets/liquid_shape.dart';

class BrandInfoScreen extends StatefulWidget {
  const BrandInfoScreen({super.key});

  @override
  State<BrandInfoScreen> createState() => _BrandInfoScreenState();
}

class _BrandInfoScreenState extends State<BrandInfoScreen> {
  Brand? _currentBrand;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrandData();
  }

  Future<void> _loadBrandData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandJson = prefs.getString('brand_info');

      if (brandJson != null) {
        final brandMap = json.decode(brandJson) as Map<String, dynamic>;
        setState(() {
          _currentBrand = Brand.fromJson(brandMap);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading brand data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveBrandData(Brand brand) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandJson = json.encode(brand.toJson());
      await prefs.setString('brand_info', brandJson);

      setState(() {
        _currentBrand = brand;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving brand data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteBrandData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('brand_info');

      setState(() {
        _currentBrand = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Brand info deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting brand data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Brand Info')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Info'),
        actions: [
          if (_currentBrand != null) ...[
            IconButton(icon: const Icon(Icons.edit), onPressed: _showBrandForm),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
            ),
          ],
        ],
      ),
      body: _currentBrand == null ? _buildEmptyState() : _buildBrandCard(),
      floatingActionButton:
          _currentBrand == null
              ? FloatingActionButton(
                onPressed: _showBrandForm,
                child: const Icon(Icons.add),
              )
              : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No Brand Info Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your brand information to create\na shareable info card',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _showBrandForm,
            icon: const Icon(Icons.add),
            label: const Text('Add Brand Info'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard() {
    final brand = _currentBrand!;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),

                // Liquid blob shapes
                Positioned(
                  top: -40,
                  left: -40,
                  child: liquidShape(
                    context,
                    AppColors.warning.withOpacity(0.25),
                    150,
                  ),
                ),
                Positioned(
                  bottom: -30,
                  right: -20,
                  child: liquidShape(
                    context,
                    AppColors.primary.withOpacity(0.2),
                    120,
                  ),
                ),
                Positioned(
                  top: 100,
                  right: -40,
                  child: liquidShape(
                    context,
                    AppColors.accent.withOpacity(0.15),
                    100,
                  ),
                ),

                // Main card content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Brand Header
                      Row(
                        children: [
                          // Logo placeholder
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child:
                                brand.logo.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        brand.logo,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.business,
                                                  size: 40,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                ),
                                      ),
                                    )
                                    : Icon(
                                      Icons.business,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brand.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (brand.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    brand.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Contact Information
                      if (brand.email.isNotEmpty ||
                          brand.phone.isNotEmpty ||
                          brand.website.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Information',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            if (brand.email.isNotEmpty)
                              _buildContactItem(Icons.email, brand.email),
                            if (brand.phone.isNotEmpty)
                              _buildContactItem(Icons.phone, brand.phone),
                            if (brand.website.isNotEmpty)
                              _buildContactItem(Icons.language, brand.website),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // Social Media
                      if (brand.facebook.isNotEmpty ||
                          brand.instagram.isNotEmpty ||
                          brand.twitter.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Social Media',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (brand.facebook.isNotEmpty)
                                  _buildSocialIcon(
                                    Icons.facebook,
                                    brand.facebook,
                                    Colors.blue[700]!,
                                  ),
                                if (brand.instagram.isNotEmpty)
                                  _buildSocialIcon(
                                    FontAwesomeIcons.instagram,
                                    brand.instagram,
                                    Colors.purple[400]!,
                                  ),
                                if (brand.twitter.isNotEmpty)
                                  _buildSocialIcon(
                                    FontAwesomeIcons.xTwitter,
                                    brand.twitter,
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white24
                                        : Colors.black54,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // QR Code Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Share Brand Info',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: brand.toQRData(),
                                version: QrVersions.auto,
                                size: 200,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Scan to get brand contact info',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String handle, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: FaIcon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(handle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Brand Info'),
            content: const Text(
              'Are you sure you want to delete all brand information? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteBrandData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showBrandForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => BrandFormBottomSheet(
            brand: _currentBrand,
            onSave: _saveBrandData,
          ),
    );
  }
}
