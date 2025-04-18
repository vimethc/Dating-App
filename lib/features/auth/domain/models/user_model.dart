class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime birthDate;
  final String gender;
  final List<String> interests;
  final GeoPoint location;
  final DateTime createdAt;
  final DateTime lastActive;
  final List<String> photos;
  final List<String> likes;
  final List<String> matches;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.birthDate,
    required this.gender,
    required this.interests,
    required this.location,
    required this.createdAt,
    required this.lastActive,
    required this.photos,
    required this.likes,
    required this.matches,
  });

  int get age {
    return DateTime.now().difference(birthDate).inDays ~/ 365;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      birthDate: DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String,
      interests: List<String>.from(json['interests'] as List),
      location: GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      photos: List<String>.from(json['photos'] as List),
      likes: List<String>.from(json['likes'] as List),
      matches: List<String>.from(json['matches'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'interests': interests,
      'location': location.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'photos': photos,
      'likes': likes,
      'matches': matches,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    DateTime? birthDate,
    String? gender,
    List<String>? interests,
    GeoPoint? location,
    DateTime? createdAt,
    DateTime? lastActive,
    List<String>? photos,
    List<String>? likes,
    List<String>? matches,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      photos: photos ?? this.photos,
      likes: likes ?? this.likes,
      matches: matches ?? this.matches,
    );
  }
}

class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
} 