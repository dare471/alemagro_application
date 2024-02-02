class ContactModel {
  final int id;
  final String position;
  final String name;
  final String phNumber;
  final String? email;
  final int authorId;
  final bool actual;
  final String? description;
  final bool mainContact;

  ContactModel({
    required this.id,
    required this.position,
    required this.name,
    required this.phNumber,
    this.email,
    required this.authorId,
    required this.actual,
    this.description,
    required this.mainContact,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int,
      position: json['position'] as String,
      name: json['name'] as String,
      phNumber: json['phNumber'] as String,
      email: json['email'] as String?,
      authorId: json['authorId'] as int,
      actual: json['actual'] as bool,
      description: json['description'] as String?,
      mainContact: json['mainContact'] as bool,
    );
  }
}
