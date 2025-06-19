class Criterion {
  String id;
  String name;
  String description;

  Criterion({required this.id, required this.name, required this.description});

  Criterion.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      description = map['description'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
