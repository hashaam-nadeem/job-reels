class NotesModel {
  String time;
  String note;


  NotesModel(
      {
        required this.time,
        required this.note,
      });
//
  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      time : json['created_at']??"",
      note : json['note']??"",

    );
  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = time;
    data['note'] = note;

    return data;
  }
}
