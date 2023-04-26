import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:workerapp/data/model/response/document_model.dart';
import 'package:workerapp/data/model/response/notes_model.dart';

import '../data/api/Api_Handler/api_error_response.dart';
import '../data/repositry/client_repo.dart';

class ClientController extends GetxController implements GetxService {
  final ClientRepo clientRepo;
  ClientController({required this.clientRepo});

  final List<NotesModel> _notesList=[];
  List<NotesModel> get notesList=>_notesList;

  final List<DocumentModel> _documentList=[];
  List<DocumentModel> get documentList=> _documentList;

   bool _isFetchingData = true;
  bool get isDataFetching => _isFetchingData;

  Future<Map<String, dynamic>> fetchNotes({required int clientId, required int page}) async {
    _isFetchingData=true;
    update();
    Map<String,dynamic> response = await clientRepo.fetchNotes(page: page, clientId: clientId,);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _notesList.clear();
      List<dynamic> listNotes = response[API_RESPONSE.SUCCESS]['data']['data'];
      for(var data in listNotes){
        _notesList.insert(0, NotesModel.fromJson(data));
      }
    }
    _isFetchingData=false;
    update();
    return response;
  }

  Future<Map<String, dynamic>> fetchDocument({required clientId,required page}) async {
    _isFetchingData=true;
    update();
    Map<String,dynamic> response = await clientRepo.fetchDocument(clientId: clientId, page: page);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _documentList.clear();
      List<dynamic> listNotes = response[API_RESPONSE.SUCCESS]['data']['data'];
      print("listNotes...............$listNotes");
      for(var data in listNotes){
        _documentList.insert(0, DocumentModel.fromJson(data));
      }
    }
    _isFetchingData=false;
    update();
    return response;
  }


  Future<Map<String, dynamic>> fetchClientDetail({required int clientsId}) async {
    _isFetchingData=true;
    update();
    Map<String,dynamic> response = await clientRepo.fetchClientDetail(clientId: clientsId);
    _isFetchingData=false;
    update();
    return response;
  }

}