class SubCategory {
  int id;
  String name;
  String description;

  SubCategory({this.id, this.name, this.description});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "description": description};
}
