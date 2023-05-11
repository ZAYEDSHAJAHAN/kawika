import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class Datalistingpage extends StatefulWidget {
  const Datalistingpage({super.key});

  @override
  State<Datalistingpage> createState() => _DatalistingpageState();
}

class _DatalistingpageState extends State<Datalistingpage> {
  List<dynamic> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
  }

  Future<void> _loadDataFromApi() async {
    String apiUrl = 'https://jsonplaceholder.typicode.com/comments';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final dataList = jsonDecode(response.body);
        setState(() {
          _dataList = dataList;
        });
        await _cacheDataLocally(dataList);
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print(e);
      _loadCachedData();
    }
  }

  Future<void> _cacheDataLocally(List<dynamic> dataList) async {
    final db = await openDatabase('data.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY, name TEXT, email TEXT, body TEXT)');
    });

    await db.transaction((txn) async {
      for (final data in dataList) {
        await txn.rawInsert(
            'INSERT INTO data(id, name, email, body) VALUES(?, ?, ?, ?)',
            [data['id'], data['name'], data['email'], data['body']]);
      }
    });

    await db.close();
  }

  Future<void> _loadCachedData() async {
    final db = await openDatabase('data.db', version: 1);
    final List<Map<String, dynamic>> dataList =
        await db.query('data', orderBy: 'id');
    setState(() {
      _dataList = dataList;
    });
    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemCount: _dataList.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return ListTile(
            title: Text(data['name']),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['email'],
                  style: TextStyle(color: Colors.blueGrey[700]),
                ),
                Text(data['body']),
              ],
            ),
            // trailing: Text(data['body']),
          );
        },
      ),
    );
  }
}
