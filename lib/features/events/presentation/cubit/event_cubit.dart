import 'package:cc/features/events/domain/entities/event.dart';
import 'package:cc/features/events/domain/repos/event_repo.dart';
import 'package:cc/features/events/presentation/cubit/event_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepo eventRepo;

  EventCubit(this.eventRepo) : super(EventInitial());

  void fetchEvents() async {
    try {
      emit(EventLoading());
      eventRepo.getEvents().listen((events) {
        emit(EventLoaded(events));
      });
    } catch (e) {
      emit(EventError('Failed to fetch events'));
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      await eventRepo.addEvent(event);
    } catch (e) {
      emit(EventError('Failed to add event'));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await eventRepo.deleteEvent(eventId);
    } catch (e) {
      emit(EventError('Failed to delete event'));
    }
  }
}
