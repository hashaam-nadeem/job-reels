import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/util/app_strings.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_drop_down_item.dart';

class DropDownWidget extends StatelessWidget {
  final String title;
  final String ?hintText;
  final String errorMessage;
  final int initialSelectedIndex;
  final ValueListenable<bool>? isRemoveOverLayEntry;
  final ValueListenable<bool>? isResetSelection;
  final List<CustomDropdownMenuItem<dynamic>> dropDownItems;
  final Function(int index, dynamic val) onChange;
  final bool decorationNone;
  const DropDownWidget({
    Key? key,
    required this.title,
    this.hintText,
    required this.errorMessage,
    this.initialSelectedIndex = -1,
    required this.isRemoveOverLayEntry,
    required this.isResetSelection,
    required this.dropDownItems,
    required this.onChange,
    this.decorationNone = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title.isNotEmpty)
          Text(
            title,
            style: montserratRegular.copyWith(fontSize: 16, color: Theme.of(context).primaryColor,),
          ),
        if(title.isNotEmpty)
          const SizedBox(height: 5,),
        Container(
          decoration: decorationNone ? null : BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          padding: EdgeInsets.all(decorationNone ? 0 : 10),
          child: CustomDropDown(
            isRemoveOverLayEntry: isRemoveOverLayEntry,
            isResetSelection: isResetSelection,
            maxListHeight: context.height * 0.35,
            items: dropDownItems,
            hintText: hintText??"",
            borderRadius: 5,
            defaultSelectedIndex: initialSelectedIndex,
            isMultiSelect: false,
            onChanged: onChange,
          ),
        ),
        if(errorMessage.isNotEmpty)
          Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
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
      ],
    );
  }
}
