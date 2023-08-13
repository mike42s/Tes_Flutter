// Search Bar Dummy
import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  final List<String> categories = [
    'Films',
    'Books',
    'Music',
    'Food',
    'Travel',
    'Min',
    'Lengths Support..................',
    'Art',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "null");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement the search results UI here
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement suggestions that appear below the search bar as the user types
    return ListView(
      children: [
        const ListTile(title: Text('Suggestion 1')),
        const ListTile(title: Text('Suggestion 2')),
        const ListTile(title: Text('Suggestion 3')),
        // Add more suggestions as needed
        const SizedBox(
          height: 20,
        ),

        ListTile(
          title: SubJudul(
            text: 'Pernah Kamu Cari',
          ),
          isThreeLine: true,
          subtitle: Container(
            padding: const EdgeInsets.only(top: 10), // Add space here
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    // Handle category button tapped
                    showResults(context);
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 60, // Set fixed height
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      text: category,
                      textAlign: TextAlign.center,
                      color: colorDefaultAplikasi,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
