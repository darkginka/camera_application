import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera_application/camera/camera_demo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({super.key});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  List<String> abc = [];
  List<String> pqr = [];

  @override
  void initState() {
    _getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Captured Image'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CameraDemo()));
        },
      ),
      body: abc.isEmpty
          ? const Center(
              child: Text(
              'No Image captured',
              style: TextStyle(fontSize: 18),
            ))
          : ListView.builder(
              itemCount: abc.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    buildNewCard(
                        context, 'Image -${index + 1}', pqr[index], abc[index])
                  ],
                );
              },
            ),
    );
  }

  _getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      abc = prefs.getStringList('path') ?? [];
      pqr = prefs.getStringList('name') ?? [];
    });
  }

  buildNewCard(
      BuildContext context, String title, String icon, String filePath) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(File(filePath)),
              ),
            ),
          ),
          SizedBox(
            width: 350,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.030,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    icon,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.030,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
