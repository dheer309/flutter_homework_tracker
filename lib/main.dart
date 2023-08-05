import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notion_api/failure_model.dart';
import 'package:flutter_notion_api/homework_chart.dart';
import 'package:flutter_notion_api/homework_repository.dart';
import 'package:flutter_notion_api/item_model.dart';
import 'package:intl/intl.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notion Homework Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeworkScreen(),
    );
  }
}

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({Key? key}) : super(key: key);

  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = HomeworkRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework Tracker'),
      ),
      // Refresh indicator for refreshing data
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = HomeworkRepository().getItems();
          setState(() {});
        },
        child: FutureBuilder<List<Item>>(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Show piechart and list of items
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  // If index is zero, return the pie chart, else return the list
                  if (index == 0) {
                    return HomeworkChart(items: items);
                  }
                  // setting item index to -1 so that all items are shown
                  final item = items[index - 1];
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 2.0,
                        color: getSubjectColor(item.subject),
                      ),
                      // Shadow with offset downwards
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    // List content
                    child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            '${item.subject} • ${item.category} • ${DateFormat.yMMMMd().format(item.deadline)}')),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Show failure message
              final failure = snapshot.error as Failure;
              return Center(child: Text(failure.message));
            }
            // Show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// Colors for each subject listbox
getSubjectColor(String subject) {
  switch (subject) {
    case 'English':
      return Colors.red[400];
    case 'Chemistry':
      return Colors.green[400];
    case 'Physics':
      return Colors.blue[400];
    case 'Math':
      return Colors.yellow[400];
    case 'French':
      return Colors.deepPurple[400];
    case 'Biology':
      return Colors.purple[400];
    case 'CS':
      return Colors.cyan[400];
    default:
      return Colors.orange[400];
  }
}
