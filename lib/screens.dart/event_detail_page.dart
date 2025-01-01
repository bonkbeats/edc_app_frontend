import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final String eventDay;
  final String location;
  final String imageUrl;
  final String description;
  final String organiser;

  const EventDetailPage({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.eventDay,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.organiser,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.imageUrl,
                      height: 250.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.eventName,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        "summit 2024",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 40.0, color: Colors.deepPurple),
                          const SizedBox(width: 13.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.eventDate} ',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${widget.eventDay} ',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 40.0, color: Colors.deepPurple),
                          const SizedBox(width: 13.0),
                          Text(
                            widget.location,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 23,
                          ),
                          const SizedBox(width: 13.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Organiser",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.organiser,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 120.0),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Contact',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 32.0, color: Colors.grey),
                      const Text(
                        'About Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating "REGISTER NOW" button with always hover effect
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add navigation or registration logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 12.0),
                  backgroundColor:
                      Colors.deepPurpleAccent, // Always hover color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 8.0, // Always elevated
                ),
                child: const Text(
                  'REGISTER NOW',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
