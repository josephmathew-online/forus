import 'package:cc/features/events/domain/entities/event.dart';

abstract class EventRepo {
  Future<void> addEvent(Event event);
  Stream<List<Event>> getEvents();
  Future<void> deleteEvent(String eventId);
}
