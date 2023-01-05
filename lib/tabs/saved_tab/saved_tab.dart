import 'dart:io';

import 'package:trail_crumbs/tabs/saved_tab/route_info_tab.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  late final Box trailBox;

  @override
  void initState() {
    super.initState();
    trailBox = Hive.box('mapRoutes');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: trailBox.listenable(),
        builder: (context, Box box, child) {
          if (box.isEmpty) {
            return const Center(
              child: Text('You haven\'t created any routes yet.'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  var routeData = box.getAt(index);

                  return Card(
                    child: ListTile(
                      title: Text(routeData.name),
                      subtitle: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat('EEE, M/d/y ').format(routeData.startTime!),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            TextSpan(
                              text: DateFormat('h:mm a').format(routeData.startTime!),
                              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                            ),
                            const TextSpan(text: ' - ', style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: DateFormat('h:mm a').format(routeData.endTime!),
                              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      trailing: routeData.imageDataList.isNotEmpty
                          ? Image.file(File(routeData.imageDataList[0]))
                          : const Icon(Icons.no_photography),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RouteInfoTab(),
                            settings: RouteSettings(
                              arguments: RouteInfoArguments(route: routeData),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
