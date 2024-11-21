class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime lastBloodWorkDate;
  final bool isCertified;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.lastBloodWorkDate,
    required this.isCertified,
    required this.age,
  });
}
