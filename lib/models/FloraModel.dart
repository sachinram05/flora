// enum FloraTypes { indian, rural, urban, imported }

class Flora {
  Flora(
    this.favorite, {
    required this.id,
    required this.title,
    required this.desc,
    required this.image,
    required this.amount,
    required this.place,
  });

  final String id;
  final String title;
  final String desc;
  final String image;
  final String amount;
  final String place;
  bool favorite = false;
}
