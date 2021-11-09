class TodoEntity {
  final int? id;
  final int category;
  final String name;

  TodoEntity({this.id, required this.category, required this.name});

  //Factory Constructor
  factory TodoEntity.fromMap(Map<String, dynamic> json) => TodoEntity(
        id: json['id'],
        category: json['category'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'name': name,
    };
  }
}
