import 'package:edc_app/providers/teams_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTeamForm extends StatefulWidget {
  final String eventName;

  const CreateTeamForm({super.key, required this.eventName});

  @override
  _CreateTeamFormState createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final List<TextEditingController> _emailControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  Future<void> _confirmAndSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Creation'),
            content: const Text('Are you sure you want to create this team?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (confirmed ?? false) {
        _submitForm(context);
      }
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final teamName = _teamNameController.text;
    final emailIds = _emailControllers
        .map((controller) => controller.text.trim())
        .where((email) => email.isNotEmpty)
        .toList();

    try {
      await Provider.of<TeamProvider>(context, listen: false).createTeam(
        eventName: widget.eventName,
        teamName: teamName,
        emailIds: emailIds,
      );

      _teamNameController.clear();
      for (var controller in _emailControllers) {
        controller.clear();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team created successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create team: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Team')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Event: ${widget.eventName}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _teamNameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the team name';
                  }
                  return null;
                },
              ),
              ...List.generate(4, (index) {
                return TextFormField(
                  controller: _emailControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Email ID ${index + 1}',
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _confirmAndSubmit(context),
                child: const Text('Create Team & Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
