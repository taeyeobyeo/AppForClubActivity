import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String displayName;
  final String email;
  final String uid;
  final String phoneNumber;
  final String classof;
  final String level;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['displayName'] != null),
        assert(map['email'] != null),
        assert(map['uid'] != null),
        assert(map['level']!=null),
        //assert(map['phoneNumber] != null),
        level = map['level'],
        uid = map['uid'],
        displayName = map['displayName'],
        email = map['email'],
        phoneNumber = map['phoneNumber'] == null ? "미등록" 
        : map['phoneNumber'][0]
          + map['phoneNumber'][1]
          + map['phoneNumber'][2] + "-"
          + map['phoneNumber'][3]
          + map['phoneNumber'][4]
          + map['phoneNumber'][5]
          + map['phoneNumber'][6] + "-"
          + map['phoneNumber'][7]
          + map['phoneNumber'][8]
          + map['phoneNumber'][9]
          + map['phoneNumber'][10],
        classof = map['classof'] == null ? "미등록" : map['classof'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$displayName:$email>";
}