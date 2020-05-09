import 'dart:convert';
import 'dart:ui';

class Note {
  int id;
  String title;
  String content;
  DateTime date_created;
  DateTime date_last_edited;
  Color note_color;

  Note(this.id, this.title, this.content, this.date_created, this.date_last_edited,this.note_color);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'title': utf8.encode(title),
      'content': utf8.encode( content ),
      'date_created': epochFromDate( date_created ),
      'date_last_edited': epochFromDate( date_last_edited ),
      'note_color': note_color.value
    };
    if(forUpdate){  data["id"] = this.id;  }
    return data;
  }

 int epochFromDate(DateTime dt) {  return dt.millisecondsSinceEpoch ~/ 1000; }
}