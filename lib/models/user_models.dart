class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime lastBloodWorkDate;
  final bool isCertified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.lastBloodWorkDate,
    required this.isCertified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      lastBloodWorkDate: DateTime.parse(json['lastBloodWorkDate']),
      isCertified: json['isCertified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'lastBloodWorkDate': lastBloodWorkDate.toIso8601String(),
      'isCertified': isCertified,
    };
  }
}
