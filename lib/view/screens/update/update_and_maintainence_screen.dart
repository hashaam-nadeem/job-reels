import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/util/images.dart';
import 'package:glow_solar/util/styles.dart';
import 'package:glow_solar/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateAndMaintenanceScreen extends StatefulWidget {
  final bool isUpdate;
  const UpdateAndMaintenanceScreen({Key? key,required this.isUpdate}): super(key: key);

  @override
  State<UpdateAndMaintenanceScreen> createState() => _UpdateAndMaintenanceScreenState();
}

class _UpdateAndMaintenanceScreenState extends State<UpdateAndMaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Text(
              widget.isUpdate ? 'Update Available'.tr : 'System under maintenance'.tr,
              style: montserratSemiBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.08),
            Image.asset(
              widget.isUpdate ? Images.updateScreen : Images.maintenance,
              width: MediaQuery.of(context).size.height*0.4,
              height: MediaQuery.of(context).size.height*0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05),

            widget.isUpdate
                ? CustomButton(
              radius: 10,
              width: context.width*.3,
                buttonText: 'update now'.tr,
                onPressed: () async {})
                :Text(
              "Will be live soon",
              style: montserratSemiBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023, color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            ),

          ]),
        ),
      ),
    );
  }
}