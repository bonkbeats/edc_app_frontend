import 'dart:io';

import 'package:edc_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final _editFormKey = GlobalKey<FormState>();
  final _editEventNameController = TextEditingController();
  final _editLocationController = TextEditingController();
  final _editDescriptionController = TextEditingController();
  final _editOrganiserController = TextEditingController();
  final _editeventDayController = TextEditingController();
  final _editeventDateController = TextEditingController();

  //File? _imageFileCreate;
  File? _imageFileEdit;

  Future<void> _pickImage({bool isEdit = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isEdit) {
          _imageFileEdit = File(pickedFile.path);
        } else {
          //_imageFileCreate = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await Provider.of<EventProvider>(context, listen: false)
          .deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _editEvent(
      String eventId, Map<String, dynamic> eventData) async {
    _editEventNameController.text = eventData['eventname'] ?? '';
    _editLocationController.text = eventData['location'] ?? '';
    _editOrganiserController.text = eventData['organiser'] ?? '';
    _editeventDateController.text = eventData['eventDate'] ?? '';
    _editeventDayController.text = eventData['eventDay'] ?? '';
    _editDescriptionController.text = eventData['description'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Event'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Form(
                    key: _editFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                            controller: _editEventNameController,
                            label: 'Event Name'),
                        _buildTextField(
                            controller: _editLocationController,
                            label: 'Location'),
                        _buildTextField(
                            controller: _editOrganiserController,
                            label: 'Organiser'),
                        _buildTextField(
                            controller: _editeventDateController,
                            label: 'Date'),
                        _buildTextField(
                            controller: _editeventDayController, label: 'Day'),
                        _buildTextField(
                            controller: _editDescriptionController,
                            label: 'Description'),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            await _pickImage(isEdit: true);
                            setState(() {});
                          },
                          child: _imageFileEdit == null
                              ? const Icon(Icons.add_a_photo, size: 50)
                              : Image.file(
                                  _imageFileEdit!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_editFormKey.currentState!.validate()) {
                      String eventName = _editEventNameController.text;
                      String location = _editLocationController.text;
                      String organiser = _editOrganiserController.text;
                      String eventDate = _editeventDateController.text;
                      String eventDay = _editeventDayController.text;
                      String description = _editDescriptionController.text;

                      Provider.of<EventProvider>(context, listen: false)
                          .updateEvent(
                        eventId,
                        eventName,
                        location,
                        _imageFileEdit,
                        organiser,
                        eventDay,
                        eventDate,
                        description,
                      );

                      _clearEditForm();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _clearEditForm() {
    _editEventNameController.clear();
    _editLocationController.clear();
    _editOrganiserController.clear();
    _editeventDateController.clear();
    _editeventDayController.clear();
    _editDescriptionController.clear();
    setState(() {
      _imageFileEdit = null;
    });
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: Provider.of<EventProvider>(context, listen: true)
                .getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No events found.'));
              } else {
                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      child: ListTile(
                        leading: event['image'] != null &&
                                event['image'].isNotEmpty
                            ? Image.network(
                                'http://192.168.43.189:4000${event['image']}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported,
                                      size: 50);
                                },
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(event['eventname'] ?? 'Unknown Event'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Location: ${event['location'] ?? 'Unknown Location'}'),
                            Text('Day: ${event['eventDay'] ?? 'Unknown Day'}'),
                            Text(
                                'Date: ${event['eventDate'] ?? 'Unknown Date'}'),
                            Text(
                                'Organiser: ${event['organiser'] ?? 'Unknown Organiser'}'),
                            Text(
                                'Description: ${event['description'] ?? 'No Description'}'),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editEvent(event['_id'], event),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteEvent(event['_id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
