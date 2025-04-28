class University {
  final String name;
  final String country;
  final String alphaTwoCode;
  final List<String> webPages;
  final String? stateProvince;
  final int? students;
  final dynamic image;

  University({
    required this.name,
    required this.country,
    required this.alphaTwoCode,
    required this.webPages,
    this.stateProvince,
    this.students,
    this.image,
  });

  University copyWith({
    String? name,
    String? country,
    String? alphaTwoCode,
    List<String>? webPages,
    String? stateProvince,
    int? students,
    dynamic image,
  }) {
    return University(
      name: name ?? this.name,
      country: country ?? this.country,
      alphaTwoCode: alphaTwoCode ?? this.alphaTwoCode,
      webPages: webPages ?? this.webPages,
      stateProvince: stateProvince ?? this.stateProvince,
      students: students ?? this.students,
      image: image ?? this.image,
    );
  }

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      country: json['country'],
      alphaTwoCode: json['alpha_two_code'],
      webPages: List<String>.from(json['web_pages']),
      stateProvince: json['state-province'],
    );
  }
}
