import 'package:flutter/material.dart';
import 'badge_position.dart';
import 'badge_positioned.dart';

/// [FlutterBadge] class is needed to show some information about count
class FlutterBadge extends StatefulWidget {
  final int itemCount;
  final Color badgeColor;
  final Color badgeTextColor;
  final Widget icon;
  final bool hideZeroCount;
  final TextStyle ?textStyle;
  final double textSize;
  final double borderRadius;
  final BadgePosition ?position;
  final EdgeInsets contentPadding;
  final bool isShowDotInsteadValue;

  ///Constructor
  ///[key] is optional, default - true
  ///[itemCount],[icon] and [position] are required fields
  ///[hideZeroCount] is optional, default - true
  ///[badgeColor] is optional, default - red
  ///[badgeTextColor] is optional, default - white
  ///[borderRadius] is optional, default - 0.0
  ///[textStyle] is optional, default - null
  ///[textSize] is optional, default - 12.0
  ///[contentPadding] is optional, default - 5.0 for all sides
  const FlutterBadge(
      {Key ?key,
      required this.itemCount,
      required this.icon,
      this.hideZeroCount= true,
      this.badgeColor = Colors.red,
      this.badgeTextColor = Colors.white,
      this.borderRadius = 0.0,
      this.position,
      this.textStyle,
      this.isShowDotInsteadValue=false,
      this.contentPadding = const EdgeInsets.all(5.0),
      this.textSize = 12.0})
      :super(key: key);

  @override
  FlutterBadgeState createState() {
    return FlutterBadgeState();
  }
}

class FlutterBadgeState extends State<FlutterBadge> {
  @override
  Widget build(BuildContext context) {
    if (widget.hideZeroCount && widget.itemCount == 0) {
      return widget.icon;
    }
    RoundedRectangleBorder ?border = widget.itemCount < 10
        ? null
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius));
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.icon,
          BadgePositioned(
            position: widget.isShowDotInsteadValue?BadgePosition.topRight(context) :widget.position ?? BadgePosition.topRight(context),
            child: widget.isShowDotInsteadValue?Container(height: 10,width: 10,decoration:  BoxDecoration(color: Theme.of(context).primaryColor,shape: BoxShape.circle),)
                :Material(
                type: widget.itemCount < 10
                    ? MaterialType.circle
                    : MaterialType.card,
                elevation: 2.0,
                shape: border,
                color: widget.badgeColor,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.itemCount>99?"99+":widget.itemCount<0?"0":widget.itemCount.toString(),
                    // widget.itemCount.toString(),
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: 10,
                          color: widget.badgeTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
