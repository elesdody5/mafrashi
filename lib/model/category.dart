class Category {
  Category({this.id, this.name, this.imageUrl, this.status});

  int id;
  String name;
  String slug;

  String status;
  String imageUrl;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "status": status,
        "image_url": imageUrl,
      };
}
