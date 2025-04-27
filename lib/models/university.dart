class University {
  final String alphaTwoCode;
  final List<String> domains;
  final String country;
  final String? stateProvince;
  final List<String> webPages;
  final String name;

  University({
    required this.alphaTwoCode,
    required this.domains,
    required this.country,
    this.stateProvince,
    required this.webPages,
    required this.name,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      alphaTwoCode: json['alpha_two_code'] ?? '',
      domains: List<String>.from(json['domains'] ?? []),
      country: json['country'] ?? '',
      stateProvince: json['state-province'],
      webPages: List<String>.from(json['web_pages'] ?? []),
      name: json['name'] ?? '',
    );
  }
}
