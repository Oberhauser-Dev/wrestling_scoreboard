class Club {
  String? id; // Vereinsnummer
  final String name;

  Club({required this.name, this.id});

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'],
    );
  }
}
