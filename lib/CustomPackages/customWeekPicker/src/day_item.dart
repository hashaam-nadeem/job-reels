import 'package:flutter/material.dart';
import 'package:workerapp/utils/styles.dart';

/// Creates a Widget representing the day.
class DayItem extends StatelessWidget {
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeDayBackgroundColor;
  final bool available;
  final Color? dotsColor;
  final Color? dayNameColor;

  const DayItem({
    Key? key,
    required this.dayNumber,
    required this.shortName,
    required this.onTap,
    this.isSelected = false,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor,
  }) : super(key: key);

  final double height = 75.0;
  final double width = 50.0;

  _buildDay(BuildContext context) {
    final textStyle = TextStyle(
      color: available
        ? const Color(0xFFA19797)
        : const Color(0xFFA19797),
      fontSize: 15,
      fontFamily: montserratRegular.fontFamily,
      fontWeight: FontWeight.normal);
    final selectedStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: montserratRegular.fontFamily,
      fontWeight: FontWeight.w400,
      height: 0.8,
    );

    return GestureDetector(
      onTap: available ? onTap as void Function()? : null,
      child: Container(
        decoration: isSelected
          ? BoxDecoration(
          color:
          activeDayBackgroundColor ?? Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(7.0),
        )
          : const BoxDecoration(color: Colors.transparent),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 2,),
            Text(
                shortName,
              style: isSelected ? selectedStyle : textStyle,
              ),
            Text(
              dayNumber.toString(),
              style: isSelected ? selectedStyle : textStyle,
            ),
            const SizedBox(height: 2,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDay(context);
  }
}