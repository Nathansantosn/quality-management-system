class User {
  String name;
  String email;
  String password;
  String position;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.position,
  });

  User.fromMap(Map<String, dynamic> map)
    : name = map['name'],
      email = map['email'],
      password = map['password'],
      position = map['position'];

  Map<String, dynamic> toMap() {
    return {'name': name, 'password': password, 'position': position};
  }
}
