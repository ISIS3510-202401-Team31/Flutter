class Users {
  final String uid;
  final String name;
  final String email;
  String? profileImageUrl; // Puede ser nulo si el usuario no ha establecido una imagen de perfil

  Users({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });
}
