import 'dart:io';

import 'package:edc_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminEventPage extends StatefulWidget {
  const AdminEventPage({super.key});

  @override
  _AdminEventPageState createState() => _AdminEventPageState();
}

class _AdminEventPageState extends State<AdminEventPage> {
//final _formKey = GlobalKey<FormState>();
  final _createFormKey = GlobalKey<FormState>(); // For the event creation form
  //final _editFormKey = GlobalKey<FormState>(); // For the event editing form
  // Controllers for the "Create Event" form
  final _createEventNameController = TextEditingController();
  final _createLocationController = TextEditingController();
  final _creatDescriptionController = TextEditingController();
  final _creatOrganiserController = TextEditingController();
  final _createventDayController = TextEditingController();
  final _createventDateController = TextEditingController();

  // Controllers for the "Edit Event" form
  // final _editEventNameController = TextEditingController();
  // final _editLocationController = TextEditingController();
  // final _editDescriptionController = TextEditingController();
  // final _editOrganiserController = TextEditingController();
  // final _editeventDayController = TextEditingController();
  // final _editeventDateController = TextEditingController();

  File? _imageFileCreate; // For the "Create Event" form
  // File? _imageFileEdit; // For the "Edit Event" form

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _createEventNameController.dispose();
    _createLocationController.dispose();
    // _editEventNameController.dispose();
    // _editLocationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({bool isEdit = false}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isEdit) {
          // _imageFileEdit = File(pickedFile.path); // Set the image for edit
        } else {
          _imageFileCreate = File(pickedFile.path); // Set the image for create
        }
      });
    }
  }

  Future<void> _createEvent() async {
    if (_createFormKey.currentState!.validate()) {
      String eventName = _createEventNameController.text;
      String location = _createLocationController.text;
      String organiser = _creatOrganiserController.text;
      String description = _creatDescriptionController.text;
      String eventDate = _createventDateController.text;
      String eventDay = _createventDayController.text;
      try {
        // Pass the image file along with other event data
        await Provider.of<EventProvider>(context, listen: false).createEvent(
            eventName,
            location,
            _imageFileCreate,
            organiser,
            eventDay,
            eventDate,
            description);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );

        // Clear the form fields after creation
        _creatDescriptionController.clear();
        _creatOrganiserController.clear();
        _createventDateController.clear();
        _createventDayController.clear();
        _createEventNameController.clear();
        _createLocationController.clear();
        setState(() {
          _imageFileCreate = null; // Clear the selected image
        });

        // Refresh the displayed events
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Future<void> _deleteEvent(String eventId) async {
  //   try {
  //     await Provider.of<EventProvider>(context, listen: false)
  //         .deleteEvent(eventId);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Event deleted successfully!')),
  //     );
  //     setState(() {}); // Refresh the list of events
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  // Future<void> _editEvent(
  //     String eventId, Map<String, dynamic> eventData) async {
  //   // Prepopulate the form with existing event data
  //   _editEventNameController.text = eventData['eventname'] ?? '';
  //   _editLocationController.text = eventData['location'] ?? '';

  //   // Show the dialog for editing
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         // This allows us to rebuild the dialog independently
  //         builder: (context, setState) {
  //           // Use the setState inside the dialog
  //           return AlertDialog(
  //             title: const Text('Edit Event'),
  //             content: SingleChildScrollView(
  //               child: Form(
  //                 key: _editFormKey,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     TextFormField(
  //                       controller: _editEventNameController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'Event Name',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter an event name';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                     const SizedBox(height: 16),
  //                     TextFormField(
  //                       controller: _editLocationController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'Location',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter a location';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                     const SizedBox(height: 16),
  //                     TextFormField(
  //                       controller: _createventDateController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'organsier',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter a organsier';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                     const SizedBox(height: 16),
  //                     TextFormField(
  //                       controller: _editeventDateController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'date',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter a date';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                     const SizedBox(height: 16),
  //                     TextFormField(
  //                       controller: _editeventDayController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'day',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter a day';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                     const SizedBox(height: 16),
  //                     TextFormField(
  //                       controller: _editDescriptionController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'description',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter description';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                     const SizedBox(height: 16),
  //                     GestureDetector(
  //                       onTap: () async {
  //                         // When an image is selected, update the state and image
  //                         await _pickImage(isEdit: true);
  //                         setState(
  //                             () {}); // Call setState to rebuild the widget and show the image
  //                       },
  //                       child: _imageFileEdit == null
  //                           ? const Icon(Icons.add_a_photo, size: 50)
  //                           : Image.file(
  //                               _imageFileEdit!,
  //                               width: 100,
  //                               height: 100,
  //                               fit: BoxFit.cover,
  //                             ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   if (_editFormKey.currentState!.validate()) {
  //                     String eventName = _editEventNameController.text;
  //                     String location = _editLocationController.text;
  //                     String organiser = _editOrganiserController.text;
  //                     String eventDate = _editeventDateController.text;
  //                     String eventDay = _editeventDayController.text;
  //                     String description = _editDescriptionController.text;

  //                     // Update the event with the selected image
  //                     Provider.of<EventProvider>(context, listen: false)
  //                         .updateEvent(
  //                             eventId,
  //                             eventName,
  //                             location,
  //                             _imageFileEdit,
  //                             eventDay,
  //                             eventDate,
  //                             organiser,
  //                             description);

  //                     // Clear the form and close the dialog
  //                     _editEventNameController.clear();
  //                     _editLocationController.clear();
  //                     setState(() {
  //                       _imageFileEdit =
  //                           null; // Clear the image selection after saving
  //                     });

  //                     Navigator.pop(context); // Close the dialog
  //                   }
  //                 },
  //                 child: const Text('Save'),
  //               ),
  //               TextButton(
  //                 onPressed: () =>
  //                     Navigator.pop(context), // Close dialog without saving
  //                 child: const Text('Cancel'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _createFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a New Event',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _createEventNameController, label: 'Event Name'),
              _buildTextField(
                  controller: _createLocationController, label: 'Location'),
              _buildTextField(
                  controller: _creatOrganiserController, label: 'Organiser'),
              _buildTextField(
                  controller: _createventDateController, label: 'Event Date'),
              _buildTextField(
                  controller: _createventDayController, label: 'Event Day'),
              _buildTextField(
                controller: _creatDescriptionController,
                label: 'Description',
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: _imageFileCreate == null
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_a_photo, size: 50),
                        ),
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.file(
                              _imageFileCreate!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  _imageFileCreate = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Create Event',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
