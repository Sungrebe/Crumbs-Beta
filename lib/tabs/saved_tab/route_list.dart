import 'dart:convert';
import 'dart:io';

import 'package:crumbs/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RouteList extends StatefulWidget {
  final List<File> routeFiles;
  const RouteList({Key? key, required this.routeFiles}) : super(key: key);

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.routeFiles.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: localStorage.readContent(widget.routeFiles[index]),
          builder: (context, AsyncSnapshot<String?> snapshot) {
            Widget body = const SizedBox.shrink();

            if (snapshot.hasData) {
              var fileJson = jsonDecode(snapshot.data!);

              Uint8List firstPhotoData = Uint8List(0);
              if (fileJson['photos'].isNotEmpty) {
                List<int> intList = List<int>.from(fileJson['photos'][0]);
                firstPhotoData = Uint8List.fromList(intList);
              }

              body = Card(
                child: ListTile(
                  title: Text(fileJson['title']),
                  subtitle: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: DateFormat('EEE, M/d/y').format(
                            DateTime.parse(fileJson['startTime']),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: DateFormat('h:mm a').format(
                            DateTime.parse(fileJson['startTime']),
                          ),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(text: ' - '),
                        TextSpan(
                          text: DateFormat('h:mm a').format(
                            DateTime.parse(fileJson['endTime']),
                          ),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Image.memory(
                    firstPhotoData,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image);
                    },
                  ),
                ),
              );
            }

            return body;
          },
        );
      },
    );
  }
}
