class ReportFlag {
  int id;
  String name;
  String description;
  bool active;

  ReportFlag({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
  });

  factory ReportFlag.fromJson(Map<String, dynamic> json) {
    return ReportFlag(
      id : json['id'],
      name : json['name'],
      description : json['description'],
      active : json['active']==1,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['active'] = active? 1 : 0;
    return data;
  }
}