class ParticipantTag {
  int id;
  String name;

  ParticipantTag(
      {
        required this.id,
        required this.name,

      });
//
  factory ParticipantTag.fromJson(Map<String, dynamic> json) {
    return ParticipantTag(
      id : json['id'],
      name : json['name']??"",

    );
  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
