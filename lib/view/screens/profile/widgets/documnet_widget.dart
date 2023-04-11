import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workerapp/controller/client_controller.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/base/custom_button.dart';

import '../../../../helper/route_helper.dart';

class DocumentWidget extends StatefulWidget {
  final bool? isAdd;
  const DocumentWidget({Key? key, this.isAdd=true}) : super(key: key);

  @override
  State<DocumentWidget> createState() => _DocumentWidgetState();
}

class _DocumentWidgetState extends State<DocumentWidget> {
  @override
  void initState() {

     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       Get.find<ClientController>().fetchDocument();
     });
    //     value) {
    //   if (value.containsKey(API_RESPONSE.SUCCESS)) {
    //     shiftModel = ShiftModel.fromJson(value[API_RESPONSE.SUCCESS]['data']);
    //     setState(() {});
    //   }
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(builder: (clientController){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                  ),
                  child:(clientController.isDataFetching && clientController.documentList.isEmpty)?
                      ListView(
                        shrinkWrap: true,
                        children: [
                          documentShimmer(),
                          documentShimmer(),
                          documentShimmer(),
                          documentShimmer(),
                        ],
                      ):
                  ListView.builder(
                    itemCount:clientController.documentList.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final String iconData = ".${clientController.documentList[index].fileName.split(".").last}";
                      return Column(
                        children:  [
                          const SizedBox(height: 5,),
                          DocumentRow(
                            iconWidget: clientController.documentList[index].filetype =="file" ?const Icon(Icons.file_present_rounded, size: 35,): Image.asset(Images.folder,color: const Color(0xFF1554F6),height: 18,width: 20,),
                            //leadingIcon: Images.folder,
                            title: clientController.documentList[index].shortFileName,
                            counter: null,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Divider(),
                          ),
                          // DocumentRow(
                          //   leadingIcon: Images.pdf,
                          //   title: 'Profile',
                          //   counter: null,
                          //   isColoredIcon: false,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 30),
                          //   child: Divider(),
                          // ),
                          // DocumentRow(
                          //   leadingIcon: Images.jpeg,
                          //   title: 'Wheelchair- front',
                          //   counter: null,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 30),
                          //   child: Divider(),
                          // ),
                          // DocumentRow(
                          //   leadingIcon: Images.jpeg,
                          //   title: 'Taxi position',
                          //   counter: null,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 30),
                          //   child: Divider(),
                          // ),
                          // DocumentRow(
                          //   leadingIcon: Images.wordDoc,
                          //   title: 'Nutrition and Swallowing Checklist',
                          //   counter: null,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 30),
                          //   child: Divider(),
                          // ),
                          // DocumentRow(
                          //   leadingIcon: Images.wordDoc,
                          //   title: 'Hazardous Substance and material type Hazardous Substance and material type document for future.....',
                          //   counter: null,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 30),
                          //   child: Divider(),
                          // ),
                          // SizedBox(height: 5,),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15,),
          widget.isAdd!?Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 25),
                decoration: const BoxDecoration(
                  color: Color(0xFF65DACC),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: (){
                    Get.toNamed(RouteHelper.getStaffAvailability());
                  },
                  iconSize: 30,
                  icon: const Icon(Icons.add,color: Colors.white,),
                ),
              ),
            ],
          ): const SizedBox(),
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
          const SizedBox(height: 20,),
        ],
      );
    });

    }
  Widget documentShimmer(){
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

class DocumentRow extends StatelessWidget {
  // final String? leadingIcon;
  final String title;
  final int ?counter;
  final bool isColoredIcon;
  final Widget? iconWidget;
  const DocumentRow({Key? key, required this.title, required this.counter,this.isColoredIcon=true, this.iconWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color blueColor = const Color(0xFF1554F6);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      child: Row(
        children: [
          iconWidget??const SizedBox(),
              //Image.asset(leadingIcon??"",color: isColoredIcon? null : blueColor,height: 18,width: 20,),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(
              title,
              style: montserratRegular.copyWith(fontSize: 10,fontWeight: FontWeight.w600,color: Colors.black),
              maxLines: 1,
            ),
          ),
          counter!=null
              ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBDBDBD),),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  counter!.toString(),
                  style: montserratRegular.copyWith(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.black),
                ),
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}