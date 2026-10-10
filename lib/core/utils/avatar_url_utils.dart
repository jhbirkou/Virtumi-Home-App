/// Helpers for avatar CDN URLs and [CachedNetworkImage] cache keys.
String avatarBaseUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.queryParameters.isEmpty) return url;
  return uri.replace(queryParameters: {}).toString();
}

String avatarUrlWithCacheBuster(String url) {
  final base = avatarBaseUrl(url);
  final uri = Uri.parse(base);
  return uri
      .replace(
        queryParameters: {
          'v': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      )
      .toString();
}
