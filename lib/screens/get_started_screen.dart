import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:krishi/screens/sign_up_screen.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';

class GetStartedScreen extends StatelessWidget {
  GetStartedScreen({super.key});

  final List<String> imageList = [
    'assets/get_started_1st.png',
    'assets/get_started_2nd.png',
    'assets/get_started_3rd.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDBE9B0), // Set background color
      body: Column(
        children: [
          TopBarGetStarted(),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    height: 300.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: imageList
                      .map((item) => Container(
                            margin: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                item,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 10),
                Text(
                  'by',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Green Horizons',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 9),
                Text(
                  ' Grow Smarter,\nHarvest Better!',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 9),
                Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 50.0), // Moved button up
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 60, vertical: 24), // Bigger button
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                              color: Color(0xFFDBE9B0),
                              fontSize: 19), // Bigger text
                        ),
                        SizedBox(width: 30),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBE9B0), // Background color
                            shape: BoxShape.circle, // Circular background
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 24,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
