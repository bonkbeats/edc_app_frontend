import 'package:edc_app/providers/public_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PublicProfileProvider>(context, listen: false)
        .fetchAllProfiles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text;
    Provider.of<PublicProfileProvider>(context, listen: false)
        .searchProfile(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Team',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 29),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search profiles...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              ),
              onChanged: (query) {
                _onSearch();
              },
            ),
          ),
          Expanded(
            child: Consumer<PublicProfileProvider>(
              builder: (context, provider, child) {
                if (provider.profiles.isEmpty && provider.noResultsFound) {
                  return const Center(child: Text('No profiles found.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25.0,
                    mainAxisSpacing: 25.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: provider.profiles.length,
                  itemBuilder: (context, index) {
                    final profile = provider.profiles[index];

                    return Card(
                      color: Colors.white,
                      elevation: 9.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipOval(
                              child: profile['image'] != null
                                  ? Image.network(
                                      '${profile['image']}',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      size: 100),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              profile['name'] ?? 'Unknown Name',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            profile['position'] ?? 'No Position',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.purple),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
