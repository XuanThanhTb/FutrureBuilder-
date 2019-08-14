import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
        home: FutureBuilderApp(title: 'Users'),
    );
  }
}

class FutureBuilderApp extends StatefulWidget{
  final String title;
  const FutureBuilderApp({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FutureBuilderAppState();
  }
}

class FutureBuilderAppState extends State<FutureBuilderApp>{
  Future<List<Users>> _getusers() async {
    var data = await http.get('https://api.apixu.com/v1/forecast.json?key=a9a98a4dc3f047d3a9265355180108&q=Paris&days=7&fbclid=IwAR3RyJcpEZwgv0aErdgkXKGKPLhrQcjOGomA0Dbas1NZq40IXrEV4ZMod88');
    Map<String, dynamic> jsonData = json.decode(data.body);
    List<Users> users = [];
    // debugger();
      final result = jsonData.values;
      // debugger();
      for(var item in result){
        var user = Users.fromJson(item);
        // debugger();
        users.add(user);
        print(users.length);
      }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder', style: TextStyle(color: Colors.black, fontSize: 24),),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getusers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text('Loading...', style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              );
            }else{
              return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data[index].name),
                    Text(snapshot.data[index].region),
                    Text(snapshot.data[index].country),
                    Text(snapshot.data[index].lat.toString()),
                    Text(snapshot.data[index].lon.toString()),
                    Text(snapshot.data[index].localtime),
                  ],
                );
                // return ListTile(
                //   title: Text(snapshot.data[index].name),
                //   subtitle: Text(snapshot.data[index].region),
                //   );
                },
              );
            } 
          },
        ),
      ),
    );
  }
}
// class Users{
//   final int index;
//   final String about;
//   final String name;
//   final String email;
//   final String picture;
//   Users(this.index, this.about, this.name, this.email, this.picture);
// }
class Users{
  // final int index;
  // final String about;
  final String name;
  // final String email;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime;
  // final String tz_id;
  // final String picture;
  // Users(this.index, this.about, this.name, this.email, this.picture);
  Users(this.name, this.region, this.country, this.lat, this.lon, this.localtime);
  Users.fromJson(Map<String, dynamic> json) : 
    name = json['name'], region = json['region'], 
    country = json['country'], lat = json['lat'], 
    lon = json['lon'], localtime = json['localtime'];
}
