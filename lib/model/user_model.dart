class UserModel {
  String? name;
  String? id;
  String? phone;
  String? type;
  String? childEmail;
  String? guardianEmail;

  UserModel({
    this.name,
    this.childEmail,
    this.id,
    this.guardianEmail,
    this.phone,
    this.type
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        "id": id,
        'childEmail': childEmail,
        'guardianEmail': guardianEmail,
        'type':type,
      };
}
