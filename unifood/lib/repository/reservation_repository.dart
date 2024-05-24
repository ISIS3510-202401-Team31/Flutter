import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/model/reservation_entity.dart';

class ReservationRepository {
  final FirebaseFirestore firestore;

  ReservationRepository(this.firestore);

  Future<void> addReservation(String userId, Reservation reservation) async {
    final reservationsRef = firestore.collection('users').doc(userId).collection('reservations');
    await reservationsRef.add(reservation.toJson());
  }

  Future<List<Reservation>> getUserReservations(String userId) async {
    final reservationsRef = firestore.collection('users').doc(userId).collection('reservations');
    final snapshot = await reservationsRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;  // Include the document ID in the data map
      return Reservation.fromJson(data);
    }).toList();
  }

  Future<void> deleteReservation(String userId, String reservationId) async {
    final reservationRef = firestore.collection('users').doc(userId).collection('reservations').doc(reservationId);
    await reservationRef.delete();
  }
}
