class State{
  final String stateName;
  final List<String> stateCities;
  State({required this.stateName, required this.stateCities});

  factory State.fromJson(Map<String, dynamic>json){
    return State(
      stateName: json['state'],
      stateCities: List<Steing>.from(json['state']),
    );
  }
}
