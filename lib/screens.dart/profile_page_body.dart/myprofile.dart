import 'package:edc_app/providers/auth_provider.dart';
import 'package:edc_app/providers/teams_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Myprofile extends StatelessWidget {
  const Myprofile({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${authProvider.userName ?? 'Guest'}!'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: teamProvider.getTeamsByUser(), // Fetching teams
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No teams found.'));
          } else {
            final teams = snapshot.data!;
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                final emails = (team['emailIds'] as List)
                    .join(', '); // Joining emails into a single string

                return ListTile(
                  title: Text(team['teamName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event: ${team['eventName']}'),
                      Text('Emails: $emails'), // Displaying emails
                    ],
                  ),
                  onTap: () {
                    // Optional: Add functionality on tap if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
