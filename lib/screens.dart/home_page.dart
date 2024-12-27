import 'package:edc_app/providers/event_provider.dart';
import 'package:edc_app/providers/public_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return searchandfilter();
  }
}

class searchandfilter extends StatefulWidget {
  const searchandfilter({super.key});

  @override
  State<searchandfilter> createState() => _searchandfilterState();
}

class _searchandfilterState extends State<searchandfilter> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          // Fills the entire screen
          child: Container(color: Colors.white),
        ),
        Positioned(
          top: 0, // Position the pink container at the bottom
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60.0),
              bottomRight: Radius.circular(60.0),
            ),
            child: Container(
              color: Colors.pink,
              height: 200.0, // Adjust height as needed
            ),
          ),
        ),
        Positioned(
            top: 175,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Formal'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Informal'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Semiformal'),
                ),
              ],
            )),
        const Positioned(
            top: 230,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: SingleChildScrollView(child: upcommingevent()))
      ],
    );
  }
}

class upcommingevent extends StatefulWidget {
  const upcommingevent({super.key});

  @override
  State<upcommingevent> createState() => _upcommingeventState();
}

class _upcommingeventState extends State<upcommingevent> {
  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    await Provider.of<PublicEventProvider>(context, listen: false)
        .fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<PublicEventProvider>(context);
    final events = eventProvider.events;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          events.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 16.0,
                  children: events.map((event) {
                    return EventCard(
                      eventName: event['eventName'] ?? 'Unknown Event',
                      date: event['date'] ?? 'Unknown Date',
                      time: event['time'] ?? 'Unknown Time',
                      location: event['location'] ?? 'Unknown Location',
                      imageUrl: event['image'] ?? 'assets/placeholder.jpg',
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String date;
  final String time;
  final String location;
  final String imageUrl;

  const EventCard({
    super.key,
    required this.eventName,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3, // Half screen width
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imageUrl, height: 150.0, fit: BoxFit.cover),
              const SizedBox(height: 16.0),
              Text(
                eventName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('Date: $date'),
              const SizedBox(height: 8.0),
              Text('Time: $time'),
              const SizedBox(height: 8.0),
              Text(location),
            ],
          ),
        ),
      ),
    );
  }
}
