import 'package:cc/features/auth/domain/entities/app_user.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/events/services/sent_event_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cc/features/events/domain/entities/event.dart';
import 'package:cc/features/events/presentation/cubit/event_cubit.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _selectedDate = DateTime.now();
  AppUser? currentUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newEvent = Event(
        id: UniqueKey().toString(),
        userId: currentUser!.uid,
        title: _title,
        description: _description,
        dateTime: _selectedDate,
      );
      FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          sendPushNotification(token, _title, _description);
        }
        // ignore: use_build_context_synchronously
        context.read<EventCubit>().addEvent(newEvent);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    try {
      // Pick a Date
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate == null) return; // User canceled

      // Pick a Time
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime == null) return; // User canceled

      // Combine Date & Time
      final DateTime newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Update the state
      setState(() {
        _selectedDate = newDateTime;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Event Date: ${_selectedDate.toLocal()}".split(' ')[0],
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () => _selectDateTime(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
