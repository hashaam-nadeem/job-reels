class SocialLinks {
  final SocialMedia upwork;
  final SocialMedia fiverr;
  final SocialMedia linkedIn;
  final SocialMedia instagram;
  final SocialMedia facebook;
  final SocialMedia youtube;
  final SocialMedia tiktok;
  final SocialMedia twitter;

  SocialLinks({
    required this.upwork,
    required this.fiverr,
    required this.linkedIn,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.tiktok,
    required this.twitter,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      upwork: SocialMedia(name: json['upwork'] ?? "", url: json['upwork']),
      fiverr: SocialMedia(name: json['fiverr'] ?? "", url: json['fiverr']),
      linkedIn:
          SocialMedia(name: json['linkedin'] ?? "", url: json['linkedin']),
      instagram:
          SocialMedia(name: json['instagram'] ?? "", url: json['instagram']),
      facebook:
          SocialMedia(name: json['facebook'] ?? "", url: json['facebook']),
      youtube: SocialMedia(name: json['youtube'] ?? "", url: json['youtube']),
      tiktok: SocialMedia(name: json['tiktok'] ?? "", url: json['tiktok']),
      twitter: SocialMedia(name: json['twitter'] ?? "", url: json['twitter']),
    );
  }

  factory SocialLinks.defaultObject() {
    return SocialLinks(
      upwork: SocialMedia(name: "Upwork", url: null),
      fiverr: SocialMedia(name: "Fiverr", url: null),
      linkedIn: SocialMedia(name: "LinkedIn", url: null),
      instagram: SocialMedia(name: "Instagram", url: null),
      facebook: SocialMedia(name: "Facebook", url: null),
      youtube: SocialMedia(name: "YouTube", url: null),
      tiktok: SocialMedia(name: "TikTok", url: null),
      twitter: SocialMedia(name: "X", url: null),
    );
  }
}

class SocialMedia {
  final String name;
  String? url;
  SocialMedia({required this.name, required this.url});
}
