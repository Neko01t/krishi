import 'package:flutter/material.dart';
import 'package:krishi/models/circle_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  final CircleData circle;

  const DataScreen({super.key, required this.circle});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Map<String, String>> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/Neko01t/api/refs/heads/main/news.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic>? newsForItem = jsonData[widget.circle.name];

        if (newsForItem != null) {
          setState(() {
            newsList = newsForItem.map<Map<String, String>>((item) {
              return {
                "title": item["title"]?.toString() ?? "No title",
                "subtitle": item["subtitle"]?.toString() ?? "No subtitle",
                "content":
                    item["content"]?.toString() ?? "No content available."
              };
            }).toList();
          });
        }
      }
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.circle.name)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'hero-${widget.circle.name}',
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          widget.circle.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.circle.description ??
                              "No description available.",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        if (widget.circle.imageUrl.isNotEmpty)
                          Image.asset(
                            widget.circle.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const Text("Latest News",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        isLoading
                            ? const CircularProgressIndicator()
                            : newsList.isEmpty
                                ? const Text("No news available.")
                                : Column(
                                    children: newsList.map((news) {
                                      return ListTile(
                                        leading:
                                            const Icon(Icons.article_outlined),
                                        title:
                                            Text(news['title'] ?? "No title"),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                news['subtitle'] ??
                                                    "No subtitle",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(height: 5),
                                            Text(
                                                news['content'] ??
                                                    "No content available.",
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}