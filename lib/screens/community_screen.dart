import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krishi/screens/add_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  CommunityScreenState createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  String selectedFilter = '';
  final List<Map<String, dynamic>> posts = [
    {
      'username': 'Sarvesh Ghodke.',
      'time': '21 h',
      'crop': 'Grape',
      'image': 'assets/community_grapes.jpg}',
      'description':
          'My crop on the grapes are not Growing properly.Can any one help me with this issue: #Healthy',
      'likes': 9,
      'isliked': false,
      'comments': 1
    },
    {
      'username': 'Aniket Mundhe',
      'time': '2 h',
      'crop': 'mango',
      'image': 'assets/community_mango.jpeg',
      'description':
          'I lost my two big mango trees due to this disease. Can any one help me with this issue: #Disease.Can anyone Help me with the best solution?',
      'likes': 10,
      'isliked': false,
      'comments': 0
    },
    {
      'username': 'Naushad Siddique',
      'time': '2 h',
      'crop': 'mango',
      'image': 'assets/unripemango_community.jpg',
      'description':
          "My mango trees are constantly under attack; diseases and pests steal my harvest, leaving me with little to show for my work.",
      'likes': 12091,
      'isliked': false,
      'comments': 90
    },
  ];
  void _addNewPost(Map<String, dynamic> newPost) {
    setState(() {
      posts.insert(0, newPost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(bottom: 4.0, top: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in Community',
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterChip('Grape'),
                    _buildFilterChip('Wheat'),
                    _buildFilterChip('Mango'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(posts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostScreen(),
            ),
          );

          if (newPost != null) {
            _addNewPost(newPost);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Makes it rounded
        ),

        selected: selectedFilter == label, // Check if selected
        selectedColor: Colors.green.shade300, // Highlight when selected
        backgroundColor: Colors.grey.shade200, // Default color
        label: Text(label),
        onSelected: (bool isSelected) {
          setState(() {
            selectedFilter = isSelected ? label : ''; // Toggle selection
          });
        },
      ),
    );
  }

  Widget _tryFileImage(String path) {
    final file = File(path);
    return file.existsSync()
        ? Image.file(
            file,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.asset(
            path.replaceAll("}", ""),
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text(post['username']),
            subtitle: Text('${post['time']} · ${post['crop']}'),
          ),
          if (post['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: post['image'].startsWith('assets/')
                  ? Image.asset(
                      post['image'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // If asset loading fails, try loading as a file
                        return _tryFileImage(post['image']);
                      },
                    )
                  : _tryFileImage(post['image']),
            ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(post['description']),
          ),
          OverflowBar(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: post['isliked'] ? Colors.green : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      if (post['isliked'] ?? false) {
                        if (post['isliked']) post['likes']--;
                      } else {
                        post['likes']++;
                      }
                      post['isliked'] = !post['isliked'];
                    });
                  }),
              Text(post['likes'] >= 1000
                  ? '${(post['likes'] / 1000).toStringAsFixed(1)}k'
                  : post['likes'].toString()),
              IconButton(icon: Icon(Icons.comment), onPressed: () {}),
              Text("${post['comments']}"),
              IconButton(icon: Icon(Icons.share), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }
}