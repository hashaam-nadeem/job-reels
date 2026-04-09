class StateClass{
  final String stateName;
  final List<String> stateCities;
  StateClass({required this.stateName, required this.stateCities});

  factory StateClass.fromJson(Map<String, dynamic>json){
    return StateClass(
      stateName: json['state'],
      stateCities: List<String>.from(json['cities']).map((e) => e).toList(),
    );
  }
}
