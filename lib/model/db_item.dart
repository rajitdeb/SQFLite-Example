class DBItem {
  int? id;
  String title;
  String description;
  String? createdAt;

  DBItem(this.id, this.title, this.description, this.createdAt);

  Map<String, dynamic> toMap() {
    if (createdAt != null) {
      return {
        'title': title,
        'description': description,
        'createdAt': createdAt
      };
    } else {
      return {'title': title, 'description': description};
    }
  }

  factory DBItem.fromMap(Map<String, dynamic> mapItem) {
    return DBItem(
      mapItem['id'],
      mapItem['title'],
      mapItem['description'],
      mapItem['createdAt'],
    );
  }
}
