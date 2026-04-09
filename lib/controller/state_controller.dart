import 'package:get/get.dart';
import 'package:jobreels/data/repository/state_repo.dart';
import 'package:jobreels/enums/country.dart';
import '../data/api/Api_Handler/api_error_response.dart';
import '../data/model/response/state_city_model.dart';

class StateController extends GetxController implements GetxService{
  final StateRepo stateRepo;
  StateController({required this.stateRepo});

  final List<StateClass> _stateList = [];
  List<StateClass> get stateList => _stateList;
  bool _isFetchingData = true;
  bool get isDataFetching => _isFetchingData;
  Country ?previouslyFetchedCountry;

  Future<List<StateClass>> getStateList(Country country)async{
    if((previouslyFetchedCountry==null || previouslyFetchedCountry!=country)){
      Map<String, dynamic> result = await stateRepo.getStateList(country);
      if(result.containsKey(API_RESPONSE.SUCCESS)){
        List<dynamic> listState = result[API_RESPONSE.SUCCESS]['data'];
        _stateList.clear();
        for(var data in listState){
          StateClass state = StateClass.fromJson(data);
          _stateList.add(state);
        }
        previouslyFetchedCountry = country;
      }
    }
    _isFetchingData = false;
    update();
    return _stateList;
  }
}