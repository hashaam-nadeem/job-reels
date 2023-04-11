import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/styles.dart';

class CustomTimeLineWidget extends StatelessWidget {
  final int tileNumber;
  final Image? iconImage;
  final Color? circleColor;
  final String tileTitle;
  final Widget tileChildWidget;
  final Widget? titleRowWidget;
  final bool isFirst;
  final bool isLast;
  const CustomTimeLineWidget({Key? key, required this.tileNumber, required this.tileTitle, required this.tileChildWidget,this.isFirst=true, this.isLast=false, this.iconImage, this.circleColor, this.titleRowWidget=const SizedBox()}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(

      nodeAlign: TimelineNodeAlign.start,
      node: TimelineNode(
        indicatorPosition: 0.0,
        indicator: Container(
          height: 30,
          width: 30,
          decoration:  BoxDecoration(
            color: circleColor ?? const Color(0xFF6A7580),
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Text(
                  '$tileNumber',
                style: montserratBold.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                ),
              ),
          ),
        ),
        endConnector: isLast? null:  const VerticalDivider(thickness: 2,),
        startConnector: isFirst? null:  const VerticalDivider(thickness: 2,),
      ),
      contents: Padding(
        padding: const EdgeInsets.only(left: 15,bottom: 4,top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  tileTitle,
                  style: montserratBold.copyWith(
                    color: const Color(0xFF160042),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 20,),
                iconImage!=null?iconImage!:const SizedBox(),
                const Spacer(),
                titleRowWidget!,
              ],

            ),
            tileChildWidget,
          ],
        ),
      ),

    );
  }
}
