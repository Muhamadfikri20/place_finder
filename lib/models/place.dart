class Place {
  final String name;
  final double latitude;
  final double longitude;
  final String placeId;
  final String photoURL;

  Place({required this.name, required this.placeId, required this.latitude, required this.longitude, required this.photoURL});

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json["geometry"]["location"];
    Iterable photos = json["photos"];

    return Place(
        placeId: json["place_id"],
        name: json["name"],
        latitude: location["lat"],
        longitude: location["lng"],
        photoURL: photos == null || photos.isEmpty ? "images/place-holder.png" : photos.first["photo_reference"].toString());
  }
}
