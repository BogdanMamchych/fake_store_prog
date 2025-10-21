class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    int id = 0;
    final rawId = json['id'];
    if (rawId is int) {
      id = rawId;
    } else if (rawId is String) {
      id = int.tryParse(rawId) ?? 0;
    }

    String name = '';
    final rawName = json['name'];
    if (rawName is String) {
      name = rawName;
    } else if (rawName is Map) {
      final first =
          (rawName['firstname'] ??
                  rawName['firstName'] ??
                  rawName['first'] ??
                  '')
              ?.toString() ??
          '';
      final last =
          (rawName['lastname'] ?? rawName['lastName'] ?? rawName['last'] ?? '')
              ?.toString() ??
          '';
      name = ('$first $last').trim();
      if (name.isEmpty) {
        name = rawName.values
            .map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .join(' ');
      }
    } else {
      name = json['username']?.toString() ?? '';
    }

    String email =
        json['email']?.toString() ?? json['username']?.toString() ?? '';

    return User(id: id, name: name, email: email);
  }
}
