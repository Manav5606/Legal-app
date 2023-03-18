class Qualification {
  final String id;
  final String name;
  final String createdAt;

  Qualification(this.id, this.name, this.createdAt);

  Map<String, dynamic> toJson() => {"name": name, "created_at": createdAt};
}
