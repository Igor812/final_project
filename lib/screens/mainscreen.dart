import 'dart:convert';

import 'package:final_project/model/detail.dart';
import 'package:final_project/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<User>> _fetchUsersList() async {
  final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load users from API');
  }
}

Future<List<Detail>> _detailUsersList() async {
  final response = await http.get(Uri.parse(
      "https://jsonplaceholder.typicode.com/todos?userId=" + detailId!));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((detail) => Detail.fromJson(detail)).toList();
  } else {
    throw Exception('Failed to load users from API');
  }
}

String? detailId;
late List<User> usersListData;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => const FirstScreen(),
      '/DetailScreen': (context) => const DetailScreen(),
    });
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  late Future<List<User>> futureUsersList;

  @override
  void initState() {
    super.initState();
    futureUsersList = _fetchUsersList();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: DetailScreen',
      style: optionStyle,
    ),
  ];

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Первая страница'),
        toolbarHeight: 40,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child:
                  Text('Главное окно', style: TextStyle(color: Colors.white))),
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/DetailScreen');
              },
              icon: Icon(Icons.navigate_next)),
        ],
      );

  Widget _navigationDraw() => Drawer(
          child: ListView(padding: EdgeInsets.only(left: 10), children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Image.asset(
                      "assets/fon.jpg",
                    ),
                  ),
                  const Text("Информация о пользователях",
                      textAlign: TextAlign.center),
                ],
              )),
        ),
        ListTile(
          leading: const Icon(Icons.first_page),
          title: const Text('Список пользователей'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.navigate_next),
          title: const Text('Детальная информация'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/DetailScreen');
          },
        ),
        Divider(),
      ]));

  Widget _bottomNavigationBar() => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Полный список',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Детальная информация',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.popAndPushNamed(context, '/');
          break;
        case 1:
          Navigator.popAndPushNamed(context, '/DetailScreen');
          break;
      }
    });
  }

  ListTile _userListTile(int id, String title, String subtitle) => ListTile(
        onTap: () {
          detailId = id.toString();
          Navigator.popAndPushNamed(context, '/DetailScreen');
        },
        leading: Text(id.toString()),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
      );

  ListView _usersListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _userListTile(
              data[index].id, data[index].name, data[index].email);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        drawer: _navigationDraw(),
        bottomNavigationBar: _bottomNavigationBar(),
        body: Center(
            child: FutureBuilder<List<User>>(
                future: futureUsersList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    usersListData = snapshot.data!;
                    return _usersListView(usersListData);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                })));
  }
}

//---------

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  late Future<List<Detail>> futureDetailList;
  late List<Detail> detailListData;

  @override
  void initState() {
    super.initState();
    futureDetailList = _detailUsersList();
  }

  late int userNum = 1;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: DetailScreen',
      style: optionStyle,
    ),
  ];

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Пользователь'),
        toolbarHeight: 40,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child:
                  Text('Полный список', style: TextStyle(color: Colors.white))),
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/DetailScreen');
              },
              icon: Icon(Icons.navigate_next)),
        ],
      );

  Widget _navigationDraw() => Drawer(
          child: ListView(padding: EdgeInsets.only(left: 10), children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Image.asset(
                      "assets/fon.jpg",
                    ),
                  ),
                  const Text("Информация о пользователях",
                      textAlign: TextAlign.center),
                ],
              )),
        ),
        ListTile(
          leading: const Icon(Icons.first_page),
          title: const Text('Список пользователей'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.navigate_next),
          title: const Text('Детальная информация'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/DetailScreen');
          },
        ),
        Divider(),
      ]));

  Widget _bottomNavigationBar() => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Полный список',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Детальная информация',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.popAndPushNamed(context, '/');
          break;
        case 1:
          Navigator.popAndPushNamed(context, '/DetailScreen');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Container _detailListTile(int indexUser, String subtitle, bool text) =>
        Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Column(children: <Widget>[
              Text("Задача: " + subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
              Text(
                  "   Исполнитель:" +
                      "  ID-" +
                      indexUser.toString() +
                      "   " +
                      usersListData.elementAt(indexUser - 1).name +
                      ".",
                  style: TextStyle(fontSize: 12)),
              Text("phone: " + usersListData.elementAt(indexUser - 1).phone,
                  style: TextStyle(fontSize: 12)),
              Text("e-mail: " + usersListData.elementAt(indexUser - 1).email,
                  style: TextStyle(fontSize: 12)),
              Text(
                  "company: " +
                      usersListData.elementAt(indexUser - 1).company.name +
                      ",     city: " +
                      usersListData.elementAt(indexUser - 1).address.city,
                  style: TextStyle(fontSize: 12)),
            ]),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Checkbox(
                    checkColor: Colors.black,
                    value: text,
                    onChanged: (bool? value) {
                      setState(() {});
                    }),
                Text("Задача завершена"),
              ],
            )
          ]),
        );

    ListView _detailListView(data, detailId) {
      return ListView.builder(
          // itemCount: data.length,
          itemBuilder: (context, detailId) {
        return _detailListTile(data[detailId].userId, data[detailId].title,
            data[detailId].completed);
      });
    }

    return Scaffold(
      appBar: _appBar(),
      drawer: _navigationDraw(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: Center(
        child: FutureBuilder<List<Detail>>(
            future: futureDetailList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                detailListData = snapshot.data!;
                return _detailListView(detailListData, detailId);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
