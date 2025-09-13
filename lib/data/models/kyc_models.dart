// class Profile {
//   final String name;
//   final String email;
//   final String phone;
//   final String address;
//
//   Profile({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.address,
//   });
//
//   Profile copyWith({
//     String? name,
//     String? email,
//     String? phone,
//     String? address,
//   }) {
//     return Profile(
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       address: address ?? this.address,
//     );
//   }
// }


class Profile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String dateOfBirth;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String nationality;
  final String role;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    this.nationality = '',
    this.role = '',
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? gender,
    String? dateOfBirth,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? nationality,
    String? role,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      nationality: nationality ?? this.nationality,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "gender": gender,
      "date_of_birth": dateOfBirth,
      "city": city,
      "state": state,
      "country": country,
      "zip_code": zipCode,
      "nationality": nationality,
      "role": role,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      gender: json["gender"] ?? "",
      dateOfBirth: json["date_of_birth"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
      zipCode: json["zip_code"] ?? "",
      nationality: json["nationality"] ?? "",
      role: json["role"] ?? "",
    );
  }
}
