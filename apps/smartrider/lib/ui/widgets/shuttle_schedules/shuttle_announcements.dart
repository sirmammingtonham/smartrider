import 'package:flutter/material.dart';
import 'package:shared/models/shuttle/shuttle_announcement.dart';
import 'package:intl/intl.dart';

class ShuttleAnnouncements extends StatelessWidget {
  ShuttleAnnouncements({
    Key? key,
    required List<ShuttleAnnouncement> announcements,
  })  
  // ignore: prefer_initializing_formals
  : announcements = announcements,
        announcementList =
            List<dynamic>.generate(announcements.length, (index) {
          return {
            'id': index,
            'title': '${announcements[index].body}\n',
            'subtitle':
                'Date: ${DateFormat('dd/MM/yy').format(DateTime.now())}',
          };
        }),
        super(key: key);
  List<ShuttleAnnouncement> announcements = [];
  List announcementList = <dynamic>[];
  @override
  Widget build(BuildContext context) {
    return (announcementList.isNotEmpty)
        ? Scaffold(
            body: SafeArea(
              child: ListView.builder(
                itemCount: announcementList.length,
                itemBuilder: (context, index) => Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(announcementList[index]['title'].toString()),
                    visualDensity:
                        const VisualDensity(horizontal: 4, vertical: 4),
                    subtitle:
                        Text(announcementList[index]['subtitle'].toString()),
                    trailing: const Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
          )
        : const Center(child: Text('No announcements.'));
  }
}
