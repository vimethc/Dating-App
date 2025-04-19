class Profile {
  final String id;
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> images;
  final List<String> interests;
  final double distance;

  const Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.images,
    required this.interests,
    required this.distance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      location: json['location'] as String,
      bio: json['bio'] as String,
      images: List<String>.from(json['images'] as List),
      interests: List<String>.from(json['interests'] as List),
      distance: json['distance'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'location': location,
      'bio': bio,
      'images': images,
      'interests': interests,
      'distance': distance,
    };
  }
} 