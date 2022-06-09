class UrlHelper {
  static String urlForPlaceKeywordAndLocation(String keyword, double latitude, double longitude) {
    return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=restaurant&keyword=$keyword&key=AIzaSyAvF0CYj_fBai5uBmKcvyFcoHMQQgHGFSg";
  }

  static String urlForReferenceImage(String photoReferenceId) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReferenceId&key=AIzaSyAvF0CYj_fBai5uBmKcvyFcoHMQQgHGFSg";
  }
}
