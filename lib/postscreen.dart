import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _posts = [];
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body);
        });
      }
    } catch (e) {
      throw Exception('Error Fetching posts: $e');
    }
  }

  void _filterPosts(String userId) {
    setState(() {
      _filter = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _filter.isEmpty
        ? _posts
        : _posts.where((post) => post['userId'].toString() == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filter by User ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: _filterPosts,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  return ListTile(
                    title: Text(post['title']),
                    subtitle: Text(post['body']),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
