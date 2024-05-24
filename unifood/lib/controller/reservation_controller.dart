import 'package:flutter/material.dart';
import 'package:unifood/repository/reservation_repository.dart';
import 'package:unifood/model/reservation_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationController {
  final ReservationRepository reservationRepository;

  ReservationController(this.reservationRepository);

  Future<void> createReservation({
    required String userId,
    required Reservation reservation,
  }) async {
    await reservationRepository.addReservation(userId, reservation);
  }

  Future<List<Reservation>> getUserReservations(String userId) async {
    return await reservationRepository.getUserReservations(userId);
  }

  Future<void> deleteReservation(String userId, String reservationId) async {
    await reservationRepository.deleteReservation(userId, reservationId);
  }
}
