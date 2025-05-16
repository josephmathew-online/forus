import 'package:cc/features/events/domain/entities/event.dart';
import 'package:cc/features/events/domain/repos/event_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseEventRepo implements EventRepo {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  @override
  Future<void> addEvent(Event event) async {
    await eventsCollection.doc(event.id).set(event.toJson());
  }

  @override
  Stream<List<Event>> getEvents() {
    return eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await eventsCollection.doc(eventId).delete();
    } catch (e) {
      // Handle errors appropriately
      // Optionally, rethrow or handle the error as needed
    }
  }
}
