import 'dart:io';
import 'package:edc_app/providers/edc_team.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Edcteam extends StatefulWidget {
  const Edcteam({super.key});

  @override
  State<Edcteam> createState() => _EdcteamState();
}

class _EdcteamState extends State<Edcteam> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  File? _imageFile;
  final _editFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final provider = Provider.of<EdcTeamProvider>(context, listen: false);
        await provider.createProfile(
          _nameController.text,
          _positionController.text,
          _imageFile,
        );
        if (!mounted) {
          return; // Check if the widget is still mounted before using BuildContext
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );

        // Clear form fields
        _nameController.clear();
        _positionController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editProfile(
      String profileId, Map<String, dynamic> profileData) async {
    try {
      _nameController.text = profileData['name'] ?? '';
      _positionController.text = profileData['position'] ?? '';

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Profile'),
            content: Form(
              key: _editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(controller: _nameController, label: 'Name'),
                  _buildTextField(
                      controller: _positionController, label: 'Position'),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _imageFile == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : Image.file(
                            _imageFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_editFormKey.currentState!.validate()) {
                    try {
                      Provider.of<EdcTeamProvider>(context, listen: false)
                          .updateProfile(
                        profileId,
                        _nameController.text,
                        _positionController.text,
                        _imageFile,
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating profile: $e')),
                      );
                    }
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        title: const Center(child: Text('EDC Team')),
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      ),
      body: Consumer<EdcTeamProvider>(
        builder: (context, provider, child) {
          final profilesFuture = provider.getAllProfiles();

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: profilesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No profiles found.'));
              }

              final profiles = snapshot.data!;

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: .6,
                ),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return ProfileCard(
                    name: profile['name'] ?? 'Unknown Name',
                    imageUrl: '${profile['image']}',
                    position: profile['position'] ?? 'Some position',
                    onEdit: () => _editProfile(profile['_id'], profile),
                    onDelete: () async {
                      try {
                        final profileId = profile['_id'];
                        if (profileId == null || profileId.isEmpty) {
                          throw Exception('Profile ID is missing');
                        }

                        await provider.deleteProfile(profileId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile deleted successfully!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting profile: $e')),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create Profile'),
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _positionController,
                          decoration:
                              const InputDecoration(labelText: 'Position'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a position';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickImage,
                          child: _imageFile == null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.add_a_photo)),
                                )
                              : Image.file(
                                  _imageFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevents dismissing the dialog by tapping outside
                                builder: (BuildContext context) {
                                  return const Dialog(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 16),
                                          Text('Creating profile...'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              await _createProfile();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Create Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String position;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.position,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          height: 50.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported, // Icon when the image fails to load
                                size: 80.0,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported, size: 50)),
                const SizedBox(height: 10),
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                Text(position,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 11)),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
