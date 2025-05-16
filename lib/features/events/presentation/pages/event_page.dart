import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/events/domain/entities/event.dart';
import 'package:cc/features/events/presentation/cubit/event_cubit.dart';
import 'package:cc/features/events/presentation/cubit/event_state.dart';
import 'package:cc/features/events/presentation/pages/add_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Map<DateTime, List<Event>> _events;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool isOwnItem = false;
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    _events = {};
    context.read<EventCubit>().fetchEvents();
    getCurrentUser();
  }

// Convert DateTime to only Time (HH:mm format)
  String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime); // Example: 10:30 AM
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  /// Normalize date to remove time component
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Calendar')),
      body: Column(
        children: [
          BlocListener<EventCubit, EventState>(
            listener: (context, state) {
              if (state is EventLoaded) {
                setState(() {
                  _events.clear();
                  for (var event in state.events) {
                    final eventDate = _normalizeDate(event.dateTime);
                    _events[eventDate] = (_events[eventDate] ?? [])..add(event);
                  }
                });
              }
            },
            child: BlocBuilder<EventCubit, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EventError) {
                  return Center(child: Text(state.message));
                }
                return TableCalendar<Event>(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: _getEventsForDay,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return _buildEventMarker(events.length);
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                isOwnItem = event.userId == currentUser?.uid ? true : false;
                return ListTile(
                  title: Text('${event.title} ${formatTime(event.dateTime)}'),
                  subtitle: Text(event.description),
                  trailing: isOwnItem
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<EventCubit>().deleteEvent(event.id);
                          },
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventMarker(int count) {
    return Positioned(
      bottom: 5,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        ),
      ),
    );
  }
}
