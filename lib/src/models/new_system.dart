class System {
  String id;
  String name;

  System({required this.id, required this.name});

  System.fromMap(Map<String, dynamic> map) : id = map['id'], name = map['name'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
