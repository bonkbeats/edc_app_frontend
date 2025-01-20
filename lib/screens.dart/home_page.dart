import 'package:edc_app/providers/public_event_provider.dart';
import 'package:edc_app/screens.dart/event_detail_page.dart';
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
    return const searchandfilter();
  }
}

class searchandfilter extends StatefulWidget {
  const searchandfilter({super.key});

  @override
  State<searchandfilter> createState() => _searchandfilterState();
}

class _searchandfilterState extends State<searchandfilter> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch(String query) async {
    if (query.isEmpty) {
      await Provider.of<PublicEventProvider>(context, listen: false)
          .fetchAllEvents(); // Fetch all events when search is cleared
    } else {
      await Provider.of<PublicEventProvider>(context, listen: false)
          .searchEvents(query);
    }
  }

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
                child: Container(color: Colors.pink, height: 200))),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    Colors.transparent, // Set the background to transparent
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearch,
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
    final noResultsFound = eventProvider.noResultsFound;

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
          noResultsFound
              ? const Center(child: Text("No results found"))
              : events.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                      spacing: 0.0,
                      runSpacing: 0.0,
                      children: events.map((event) {
                        return EventCard(
                          eventDay: event['eventDay'] ??
                              'Unknown Day', // Mapping for eventDay
                          organiser: event['organiser'] ??
                              'Unknown Organiser', // Mapping for organiser
                          description: event['description'] ??
                              'No Description Available', // Mapping for description
                          eventName: event['eventname'] ?? 'Unknown Event',
                          eventDate: event['eventDate'] ?? 'Unknown Date',
                          // time: event['time'] ?? 'Unknown Time',
                          location: event['location'] ?? 'Unknown Location',
                          imageUrl: '${event['image']}',
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
  final String eventDate;
  final String eventDay;
  final String location;
  final String imageUrl;
  final String description;
  final String organiser;

  const EventCard({
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(
              eventName: eventName,
              eventDate: eventDate,
              organiser: organiser,
              eventDay: eventDay,
              description: description,
              location: location,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.2, // Half screen width
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the image or fallback if it fails to load
                imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl, // Use Image.network to load image from server

                          width: double
                              .infinity, // Take full width of the container
                          height: 100.0, // Match the container height
                          fit: BoxFit
                              .cover, // Ensures the image covers the container's space

                          errorBuilder: (context, error, stackTrace) {
                            // Show placeholder if image loading fails
                            return Center(
                              child: Container(
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey[200], // Light grey background
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Light grey background
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                const SizedBox(height: 8.0),
                Text(
                  eventName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                // Text('Date: $date'),
                // const SizedBox(height: 8.0),
                // Text('Time: $time'),
                // const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on, // Location icon
                      color:
                          Colors.grey, // Same color as the text for consistency
                      size: 16.0, // Adjust size as needed
                    ),
                    const SizedBox(
                        width: 4.0), // Small space between the icon and text
                    Text(
                      location,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
