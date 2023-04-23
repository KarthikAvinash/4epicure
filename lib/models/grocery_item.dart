class GroceryItem {
  String title;
  String quantity;
  String units;
  int id;
  int user_id;

  GroceryItem({
    required this.title,
    required this.quantity,
    required this.units,
    required this.id,
    required this.user_id,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      user_id: json['user'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      quantity: json['quantity'] as String,
      units: json['unit'] as String,
    );
  }
}
