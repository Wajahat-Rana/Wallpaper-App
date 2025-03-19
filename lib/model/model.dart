class Images {
  int imageId;
  String imageAlt;
  String imagePortraitPath;

  Images({
    required this.imageId,
    required this.imageAlt,
    required this.imagePortraitPath,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    imageId: json["id"] as int,
    imageAlt: json["alt"] as String,
    imagePortraitPath: json["src"]["portrait"] as String,
  );

  Images.emptyConstructor({
    this.imageId = 1,
    this.imageAlt = '',
    this.imagePortraitPath = '',
  });
}
