import 'dart:io';

import 'package:crumbs/tabs/saved_tab/route_list.dart';
import 'package:flutter/material.dart';
/*
class SavedTab extends StatefulWidget {
  final Future<List<File>> fileList;
  const SavedTab({Key? key, required this.fileList}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: widget.fileList,
        builder: (context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 20),
                  child: Text(
                    'Saved Routes',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: RouteList(routeFiles: snapshot.data!),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('You haven\'t created any routes yet.'),
            );
          }
        },
      ),
    );
  }
}
*/