import 'package:firebase_auth/firebase_auth.dart';
import 'package:unifood/model/user_entity.dart';

class Auth {
  Future<Users?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return null; // Devolver null indicando éxito al cerrar sesión
    } catch (e) {
      print('Error al cerrar sesión: $e');
      return null; // Manejar errores de cierre de sesión aquí
    }
  }

  Future<Users?> signUpWithEmailPassword(String email, String password) async {
    try {
      if (!email.endsWith('@uniandes.edu.co')) {
        print('El correo debe ser de dominio @uniandes.edu.co');
        return null; // Devolver null si el correo no tiene el dominio correcto
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Cuenta creada exitosamente!');
      return _userFromFirebaseUser(FirebaseAuth.instance.currentUser!);
    } catch (e) {
      print('Error al crear la cuenta: $e');
      return null; // Manejar errores de creación de cuenta aquí.
    }
  }

  Future<Users?> signInWithEmailPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Cuenta iniciada exitosamente!');
      return _userFromFirebaseUser(FirebaseAuth.instance.currentUser!);
    } catch (e) {
      print('Error al autenticar: $e');
      return null; // Manejar errores de inicio de sesión aquí.
    }
  }

  // Método para convertir un usuario de Firebase a un usuario de la aplicación
  Users _userFromFirebaseUser(User firebaseUser) {
    return Users(uid: firebaseUser.uid, email: firebaseUser.email ?? '');
  }
}
