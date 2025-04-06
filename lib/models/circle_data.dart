class CircleData {
  final String name;
  final String imageUrl;
  final String? description;
  final String? news;
  const CircleData(
    {required this.name,
       required this.imageUrl,
       this.description,
       this.news});
}
