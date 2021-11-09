class CategoryEntity {
  final int? id;
  final String name;

  CategoryEntity({this.id, required this.name});

  //Factory Constructor
  factory CategoryEntity.fromMap(Map<String, dynamic> json) => CategoryEntity(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
