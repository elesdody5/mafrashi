class User {
  User({
    this.id,
    this.phone,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.email,
  });

  int id;
  String phone;
  String firstName;
  String lastName;
  String gender;
  String dateOfBirth;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        phone: json["phone"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        dateOfBirth: json["date_of_birth"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "email": email,
      };
}
