class Client {
  final int id;
  final String name;
  final String iin;
  // Другие поля...

  Client({required this.id, required this.name, required this.iin});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(id: json['id'], name: json['name'], iin: json['iinBin']
        // Другие поля...
        );
  }
}
