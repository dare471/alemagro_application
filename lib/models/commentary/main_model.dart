class CommentaryNote {
  final String id;
  final String clientId;
  final String description;
  final String createDate;
  final String updateDate;
  final String createdBy;
  final String category;

  CommentaryNote({
    required this.id,
    required this.clientId,
    required this.description,
    required this.createDate,
    required this.updateDate,
    required this.createdBy,
    required this.category,
  });

  factory CommentaryNote.fromJson(Map<String, dynamic> json) {
    return CommentaryNote(
      id: json['id'],
      clientId: json['clientId'],
      description: json['description'],
      createDate: json['createDate'],
      updateDate: json['updateDate'],
      createdBy: json['createdBy'],
      category: json['category'],
    );
  }
}
