import 'package:get/get.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_error_response.dart';
import 'package:jobreels/enums/report_type.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../data/model/helpers.dart';
import '../../../data/model/response/report_flag_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/my_text_field.dart';
import '../../base/popup_alert.dart';



class ReportVideo extends StatefulWidget {
  final int id;
  final Report reportType;
  const ReportVideo({Key? key, required this.id,required this.reportType,}) : super(key: key);

  @override
  State<ReportVideo> createState() => _ReportVideoState();
}

class _ReportVideoState extends State<ReportVideo> {

  final TextEditingController _reportDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorText = '';
  ReportFlag ?selectedReportReason;

  @override
  void initState(){

    Get.find<PostsController>().getReportFlags(widget.reportType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: widget.reportType==Report.Post ? AppString.reportVideo : AppString.reportUser,
          titleColor: Theme.of(context).primaryColorLight,
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorLight,size: 16,),
          ),
          tileColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  width: context.width,
                  padding:  const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  margin:  EdgeInsets.zero,
                  child: GetBuilder<PostsController>(builder: (postController) {
                    return Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            SizedBox(
                              height: 120,
                              child: Text(
                              AppString.reportVideoInstruction.tr,
                              textAlign: TextAlign.start,
                              style: montserratRegular.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            ),
                            Text(
                              widget.reportType==Report.Post ? AppString.iFoundThisVideoTobe.tr : AppString.iFoundThisUserTobe.tr,
                              textAlign: TextAlign.start,
                              style: montserratRegular.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            /// Report reason
                            GetBuilder<PostsController>(
                              builder: (PostsController postController){
                                int totalReportFlags = postController.reportFlagList(widget.reportType).length;
                                if(totalReportFlags==0){
                                  return const SizedBox();
                                }else{
                                  return ListView.builder(
                                    itemCount: totalReportFlags,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index){
                                      ReportFlag reportFlag = postController.reportFlagList(widget.reportType)[index];
                                      bool isSelected = selectedReportReason == reportFlag;
                                      return GestureDetector(
                                        onTap: (){
                                          selectedReportReason = reportFlag;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 70,
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(vertical: 5),
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color:  isSelected ? Theme.of(context).primaryColor : const Color(0xFFf3f3f3),
                                            border: Border.all(color: Theme.of(context).primaryColor),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                reportFlag.name,
                                                style: montserratRegular.copyWith(
                                                  color: isSelected ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  reportFlag.description,
                                                  textAlign: TextAlign.start,
                                                  style: montserratRegular.copyWith(
                                                    color: isSelected ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                }
                              }
                            ),
                            CustomInputTextField(
                              controller: _reportDescriptionController,
                              focusNode: null,
                              borderRadius: 8,
                              context: context,
                              backgroundShadow: const Color(0xfff3f3f3),
                              hintText: AppString.enterDescription,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                            if(errorText.isNotEmpty)
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,),
                                      child: Text(
                                        errorText,
                                        textAlign: TextAlign.start,
                                        style: montserratRegular.copyWith(
                                          color: Theme.of(context).errorColor,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    height: 50,
                                    radius: 8,
                                    buttonText: AppString.cancel.tr,
                                    textColor: Theme.of(context).primaryColor,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColorLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Theme.of(context).primaryColor)
                                    ),
                                    onPressed: (){
                                      Get.back();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: CustomButton(
                                    height: 50,
                                    radius: 8,
                                    buttonText: AppString.submit.tr,
                                    onPressed: (){
                                      if(selectedReportReason==null){
                                        errorText = "Report reason is required.";
                                        setState(() {});
                                      }else{
                                        errorText = "";
                                        setState(() {});
                                        postController.reportVideo(widget.id, selectedReportReason!.id, _reportDescriptionController.text.trim(), reportType:  widget.reportType).then((result){
                                          if(result.containsKey(API_RESPONSE.SUCCESS)){
                                            showPopUpAlert(
                                              popupObject: PopupObject(
                                                title: 'Success',
                                                body: '${widget.reportType==Report.Post ? "Video":"User"} reported successfully',
                                                buttonText: "Ok",
                                                onYesPressed: (){
                                                  Get.back();
                                                  Get.back();
                                                },
                                                hideTopRightCancelButton: true,
                                              ),
                                              barrierDismissible: false,
                                            );
                                          }else if(result.containsKey(API_RESPONSE.ERROR)){
                                            Map<String, dynamic>error = result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
                                            error.forEach((key, value) {
                                              errorText = "$errorText\n${(value as List).first}";
                                            });
                                            setState(() {});
                                          }else{
                                            errorText = result[API_RESPONSE.EXCEPTION];
                                            setState(() {});
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ]
                            ),
                            const SizedBox(height: 30),
                          ]),
                    );
                  }),
                ),
              ),
            )),
      ),
    );
  }
}
