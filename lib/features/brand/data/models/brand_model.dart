// Simple Brand model
class Brand {
  final String name;
  final String logo; // URL or asset path
  final String email;
  final String phone;
  final String website;
  final String facebook;
  final String instagram;
  final String twitter;
  final String description;

  Brand({
    required this.name,
    this.logo = '',
    this.email = '',
    this.phone = '',
    this.website = '',
    this.facebook = '',
    this.instagram = '',
    this.twitter = '',
    this.description = '',
  });

  // Convert to JSON for saving
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'email': email,
      'phone': phone,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'description': description,
    };
  }

  // Create from JSON
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      twitter: json['twitter'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Convert to JSON for QR code
  String toQRData() {
    return 'Brand: $name\n'
        '${email.isNotEmpty ? 'Email: $email\n' : ''}'
        '${phone.isNotEmpty ? 'Phone: $phone\n' : ''}'
        '${website.isNotEmpty ? 'Website: $website\n' : ''}'
        '${facebook.isNotEmpty ? 'Facebook: $facebook\n' : ''}'
        '${instagram.isNotEmpty ? 'Instagram: $instagram\n' : ''}'
        '${twitter.isNotEmpty ? 'Twitter: $twitter\n' : ''}';
  }
}
