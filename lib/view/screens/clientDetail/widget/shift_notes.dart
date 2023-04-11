import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workerapp/utils/app_images.dart';
import 'dart:math' as math;
import '../../../../controller/client_controller.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/styles.dart';

class ShiftNotes extends StatefulWidget {
   const ShiftNotes({Key? key}) : super(key: key);

  @override
  State<ShiftNotes> createState() => _ShiftNotesState();
}

class _ShiftNotesState extends State<ShiftNotes> {
   List<bool>? isExpandedStateList;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     await Get.find<ClientController>().fetchNotes();
      isExpandedStateList = List<bool>.generate(Get.find<ClientController>().notesList.length, (int index) => false);
    });

    super.initState();
  }

  // var now =  DateTime.now();
  // var formatter =  DateFormat.yMMMMd('en_US').add_jm();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(builder: (clientController){
      // final List<bool> isExpandedStateList = List<bool>.generate(Get.find<ClientController>().notesList.length, (int index) => false);
      return Column(
        children: [
          (clientController.isDataFetching && clientController.notesList.isEmpty)
              ? ListView(
            shrinkWrap: true,
            children: [
              notesShimmer(),
              notesShimmer(),
              notesShimmer(),
              notesShimmer(),
              notesShimmer(),
            ],
          ):
          isExpandedStateList != null
              ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clientController.notesList.length,
            shrinkWrap: true,
            itemBuilder:(BuildContext context, int index){
              bool isExpanded=isExpandedStateList![index];
              return Card(
                child: ExpansionTile(
                  onExpansionChanged: (bool expanded) {
                    setState(() => isExpandedStateList![index]= expanded);
                  },

                  trailing: clientController.notesList[index].note.isEmpty? const SizedBox():  isExpanded
                      ?  Container(
                    height: 40,
                    width: 40,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius:  3,
                          offset: const Offset(-2, 2), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(.2)),
                      color:   const Color(0xff23A6F0),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    child: Image.asset(Images.arrowUp,scale: 2,),)
                      :Container(
                    height: 40,
                    width: 40,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius:  3,
                          offset: const Offset(-2, 2), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(.2)),
                      color:   Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    child: Image.asset(Images.arrowLeft,scale: 2,),),
                  title: Text(
                    //"14.1.2022 1030AM - 1230PM",
                    DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(clientController.notesList[index].time)),
                    style: montserratRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,),
                  ),
                  children: clientController.notesList[index].note.isEmpty? []:[
                    Container(
                      padding:const EdgeInsets.all(10),
                      child: Text(
                        clientController.notesList[index].note,
                          // AppString.note
                        style: montserratRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w500,height: 1.5),
                      ),
                    )
                  ],
                ),
              );
            },
          )
              : ListView(
            shrinkWrap: true,
            children: [
              notesShimmer(),
              notesShimmer(),
              notesShimmer(),
              notesShimmer(),
              notesShimmer(),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 25),
                decoration: const BoxDecoration(
                  color: Color(0xFF65DACC),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: (){},
                  iconSize: 30,
                  icon: const Icon(Icons.add,color: Colors.white,),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Container(
            width: 350,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xFFBDBDBD)),
                color: Colors.white
            ),
            child: Row(
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7)),
                  child: Container(
                    color: const Color(0xFFF3F3F3),
                    child: TextButton(
                        onPressed: (){},
                        child: Text(
                          'First',
                          style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: const Color(0xFFBDBDBD)),
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      color: const Color(0xFFFFFFFF),
                      alignment: Alignment.center,
                      child: const Text('1')),
                ),
                Expanded(
                  child: Container(
                      color: const Color(0xFF23A6F0),
                      alignment: Alignment.center,
                      child: const Text('2')),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Container(
                      color: const Color(0xFFFFFFFF),
                      alignment: Alignment.center,
                      child: const Text('3')),
                ),
                const VerticalDivider(),
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7)),
                  child: Container(
                    color: const Color(0xFFFFFFFF),
                    child: TextButton(
                        onPressed: (){},
                        child: Text(
                          'Next',
                          style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: const Color(0xFF23A6F0)),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15,),
        ],
      );
    });
  }
  Widget notesShimmer(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Shimmer.fromColors(
          period: const Duration(milliseconds: 1500),
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              //color: Theme.of(context).backgroundColor,
              color: Colors.grey.withOpacity(.7),
              borderRadius: BorderRadius.circular(5),
              //border: Border.all(color:Theme.of(context).primaryColorDark),
            ),
            padding: const EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
