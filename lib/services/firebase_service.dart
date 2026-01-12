import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/build_kit.dart';
import '../models/reservation.dart';
import '../config/app_config.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Build Kits
  static Future<List<BuildKit>> getBuildKits() async {
    try {
      final snapshot = await _firestore.collection('buildKits').get();
      return snapshot.docs
          .map((doc) => BuildKit.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error getting build kits: $e');
      return [];
    }
  }

  static Future<BuildKit?> getBuildKit(String id) async {
    try {
      final doc = await _firestore.collection('buildKits').doc(id).get();
      if (doc.exists) {
        return BuildKit.fromMap({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      print('Error getting build kit: $e');
      return null;
    }
  }

  // Reservations
  static Future<String> createReservation(Reservation reservation) async {
    try {
      final docRef = await _firestore.collection('reservations').add(reservation.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating reservation: $e');
      rethrow;
    }
  }

  static Future<List<Reservation>> getReservationsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final snapshot = await _firestore
          .collection('reservations')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .get();
      
      return snapshot.docs
          .map((doc) => Reservation.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error getting reservations: $e');
      return [];
    }
  }

  static Future<List<Reservation>> getReservationsByCustomer(
      String name, String password) async {
    try {
      final snapshot = await _firestore
          .collection('reservations')
          .where('customerName', isEqualTo: name)
          .where('customerPassword', isEqualTo: password)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Reservation.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error getting customer reservations: $e');
      return [];
    }
  }

  static Future<void> updateReservation(Reservation reservation) async {
    try {
      await _firestore
          .collection('reservations')
          .doc(reservation.id)
          .update(reservation.toMap());
    } catch (e) {
      print('Error updating reservation: $e');
      rethrow;
    }
  }

  static Future<void> deleteReservation(String id) async {
    try {
      await _firestore.collection('reservations').doc(id).delete();
    } catch (e) {
      print('Error deleting reservation: $e');
      rethrow;
    }
  }

  // Check seat availability
  static Future<List<int>> getAvailableSeats(
      DateTime date, int startHour, int durationHours) async {
    try {
      final reservations = await getReservationsByDate(date);
      final occupiedSeats = <int>{};
      
      for (final reservation in reservations) {
        if (reservation.status == ReservationStatus.cancelled) continue;
        
        // Check time overlap
        final reservationEndHour = reservation.startHour + reservation.durationHours;
        final requestedEndHour = startHour + durationHours;
        
        if (startHour < reservationEndHour && requestedEndHour > reservation.startHour) {
          occupiedSeats.add(reservation.seatNumber);
        }
      }
      
      final allSeats = List.generate(AppConfig.seatsPerHour, (i) => i + 1);
      return allSeats.where((seat) => !occupiedSeats.contains(seat)).toList();
    } catch (e) {
      print('Error getting available seats: $e');
      return [];
    }
  }
}
