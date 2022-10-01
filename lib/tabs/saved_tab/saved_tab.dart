import 'package:crumbs/globals.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box currentBox, child) {
          if (currentBox.isEmpty) {
            return const Center(
              child: Text('You haven\'t created any routes yet.'),
            );
          } else {
            return Column(
              children: [
                const Text('Saved Routes', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentBox.length,
                    itemBuilder: (context, index) {
                      var routeData = currentBox.getAt(index);

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
                                  text: DateFormat('EEE, M/d/y ').format(routeData.startTime),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: DateFormat('h:mm a').format(routeData.startTime),
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                                const TextSpan(text: ' - '),
                                TextSpan(
                                  text: DateFormat('h:mm a').format(routeData.endTime),
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                          trailing: Image.memory(routeData.photoData.first),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
