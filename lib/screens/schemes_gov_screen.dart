import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemesDetailScreen extends StatefulWidget {
  const SchemesDetailScreen({super.key});

  @override
  _SchemesDetailScreenState createState() => _SchemesDetailScreenState();
}

class _SchemesDetailScreenState extends State<SchemesDetailScreen> {
  late List<Map<String, String>> schemes;
  List<Map<String, String>> rejectedSchemes = [];
  bool isLoading = true;
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        schemes = List.generate(4, (index) {
          return {
            'title': 'Scheme ${index + 1}',
            'description':
            'This is a detailed description for Scheme ${index + 1}. It includes all the necessary information about the scheme.',
            'extraInfo':
            'Additional details about Scheme ${index + 1}. Apply now to avail the benefits. The scheme covers various aspects such as financial aid, subsidies, and other government benefits.'
          };
        });
        isLoading = false;
      });
    });
  }

  void _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Government Schemes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: isLoading ? 12 : schemes.length,
                itemBuilder: (context, index) {
                  if (isLoading) return _buildShimmerCard();
                  var scheme = schemes[index];
                  bool isExpanded = expandedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Text(
                              scheme['description']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isExpanded) ...[
                            AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: Text(
                                scheme['extraInfo']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _launchURL,
                                  child: const Text('Apply',
                                      style: TextStyle(color: Colors.green)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      rejectedSchemes.add(schemes[index]);
                                      schemes.removeAt(index);
                                    });
                                  },
                                  child: const Text('Reject',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (rejectedSchemes.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Rejected Schemes:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rejectedSchemes.length,
                  itemBuilder: (context, index) {
                    var rejectedScheme = rejectedSchemes[index];
                    return Card(
                      margin: const EdgeInsets.all(5.0),
                      child: ListTile(
                        title: Text(rejectedScheme['title']!),
                        subtitle: Text(rejectedScheme['description']!),
                        trailing: TextButton(
                          onPressed: () {
                            setState(() {
                              schemes.add(rejectedSchemes[index]);
                              rejectedSchemes.removeAt(index);
                            });
                          },
                          child: const Text('Restore',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    );
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: 80, color: Colors.white),
            const SizedBox(height: 5),
            Container(height: 14, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }
}