import 'package:firebase_database/firebase_database.dart';
import 'package:popo/models/station.dart';

class StationsService{ 
  List<Station> _todoList;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  // getStation(){
  //   Query snapshort = _database.reference().child("Stations");
  //    stations.add(Station.fromSnapshot());
  // } 
}