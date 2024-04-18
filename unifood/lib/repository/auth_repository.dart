import 'package:firebase_auth/firebase_auth.dart';
import 'package:unifood/data/firebase_service_adapter.dart'; // Import the FirestoreServiceAdapter
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/shared_preferences.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  Auth() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _prefsService.clearUser();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'signOut',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error log out: $e');
    }
  }

  Future<Users> _fetchUserFromFirestore(String uid) async {
    final snapshot = await _firestoreServiceAdapter.getDocumentById('users', uid);
    final data = snapshot.data() as Map<String, dynamic>;
    return Users(
      uid: uid,
      name: data['name'],
      email: data['email'],
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Future<Users?> signUpWithEmailPassword(
      String name, String email, String password) async {
    try {
      if (!email.endsWith('@uniandes.edu.co')) {
        print('El correo debe ser de dominio @uniandes.edu.co');
        return null;
      }

      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users newUser = Users(
        uid: authResult.user!.uid,
        name: name,
        email: email,
        profileImageUrl: '',
      );

      await _firestoreServiceAdapter.addDocument('users', {
        'uid': authResult.user!.uid,
        'email': email,
        'name': name,
        'profileImageUrl': '',
      });

      print('Cuenta creada exitosamente!');
      return newUser;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'signUpWithEmailPassword',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error sign up: $e');
      return null;
    }
  }

  Future<Users?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users user = await _fetchUserFromFirestore(authResult.user!.uid);
      _prefsService.saveUser(user);

      print('Sesión iniciada exitosamente!');
      print('Usuario: ${user.name}');
      return user;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'signInWithEmailPassword',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error sign in: $e');
    }
    return null;
  }
}
