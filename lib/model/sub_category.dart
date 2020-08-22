class SubCategory {
  int id;
  String description;
  String slug;

  SubCategory({this.id, this.slug, this.description});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        slug: json['slug'],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
