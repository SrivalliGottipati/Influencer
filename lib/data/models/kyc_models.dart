class Profile {
  final String name;
  final String email;
  final String phone;
  final String address;

  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  Profile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
