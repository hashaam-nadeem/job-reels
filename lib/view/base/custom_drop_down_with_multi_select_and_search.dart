// import 'package:flutter/material.dart';
//
// import 'custom_drop_down_item.dart';
//
// class CustomMultiSelectDropDown<T> extends StatefulWidget {
//   final List<CustomDropdownMenuItem> items;
//   final Function(int index, dynamic value) onChanged;
//   final String hintText;
//   final double borderRadius;
//   final double maxListHeight;
//   final double borderWidth;
//   final List<int> defaultSelectedIndexs;
//   final bool enabled;
//
//   const CustomMultiSelectDropDown({
//     required this.items,
//     required this.onChanged,
//     this.hintText = "",
//     this.borderRadius = 0,
//     this.borderWidth = 1,
//     this.maxListHeight = 100,
//     required this.defaultSelectedIndexs,
//     Key? key,
//     this.enabled = true,
//   })
//       : super(key: key);
//
//   @override
//   _CustomMultiSelectDropDownState createState() => _CustomMultiSelectDropDownState();
// }
//
// class _CustomMultiSelectDropDownState extends State<CustomMultiSelectDropDown>
//     with WidgetsBindingObserver {
//   bool _isOpen = false, _isAnyItemSelected = false, _isReverse = false;
//   late OverlayEntry _overlayEntry;
//   late RenderBox? _renderBox;
//   late Offset dropDownOffset;
//   final LayerLink _layerLink = LayerLink();
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           dropDownOffset = getOffset();
//         });
//       }
//       for (int index in widget.defaultSelectedIndexs) {
//         widget.items[index].isSelected = true;
//       }
//     });
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }
//
//   void _addOverlay() {
//     if (mounted) {
//       setState(() {
//         _isOpen = true;
//       });
//     }
//
//     _overlayEntry = _createOverlayEntry();
//     Overlay.of(context)!.insert(_overlayEntry);
//   }
//
//   void _removeOverlay() {
//     if (mounted) {
//       setState(() {
//         _isOpen = false;
//       });
//       _overlayEntry.remove();
//     }
//   }
//
//   @override
//   dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   OverlayEntry _createOverlayEntry() {
//     _renderBox = context.findRenderObject() as RenderBox?;
//
//     var size = _renderBox!.size;
//
//     dropDownOffset = getOffset();
//     return OverlayEntry(
//         maintainState: false,
//         builder: (context) => Align(
//           alignment: Alignment.center,
//           child: CompositedTransformFollower(
//             link: _layerLink,
//             showWhenUnlinked: false,
//             offset: dropDownOffset,
//             child: SizedBox(
//               height: widget.maxListHeight+10,
//               width: size.width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: _isReverse
//                     ? MainAxisAlignment.end
//                     : MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Container(
//                       constraints: BoxConstraints(
//                           maxHeight: widget.maxListHeight,
//                           maxWidth: size.width),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12)),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(widget.borderRadius),
//                         ),
//                         child: Material(
//                           elevation: 0,
//                           shadowColor: Colors.grey,
//                           child: Scrollbar(
//                             controller: ScrollController(),
//                             child: ListView(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               children: widget.items.map((item) => InkWell(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: item.child,
//                                     ),
//                                     const Divider(height: 1,thickness: 1,),
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   if (mounted) {
//                                     setState(() {
//                                       _isAnyItemSelected = true;
//                                       item.isSelected = _isAnyItemSelected;
//                                       _removeOverlay();
//                                       widget.onChanged(widget.items.indexOf(item), item.value);
//                                     });
//                                   }
//                                 },
//                               ))
//                                   .toList(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Offset getOffset() {
//     RenderBox? renderBox = context.findRenderObject() as RenderBox?;
//     double y = renderBox!.localToGlobal(Offset.zero).dy;
//     double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
//     if (spaceAvailable > widget.maxListHeight) {
//       _isReverse = false;
//       return Offset(0, renderBox.size.height);
//     } else {
//       _isReverse = true;
//       return Offset(
//           0,
//           renderBox.size.height -
//               (widget.maxListHeight + renderBox.size.height));
//     }
//   }
//
//   double _getAvailableSpace(double offsetY) {
//     double safePaddingTop = MediaQuery.of(context).padding.top;
//     double safePaddingBottom = MediaQuery.of(context).padding.bottom;
//
//     double screenHeight =
//         MediaQuery.of(context).size.height - safePaddingBottom - safePaddingTop;
//
//     return screenHeight - offsetY;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: GestureDetector(
//         onTap: widget.enabled
//             ? () {
//           _isOpen ? _removeOverlay() : _addOverlay();
//         }
//             : null,
//         child: Container(
//           decoration: _getDecoration(),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Expanded(
//                 flex: 3,
//                 child: _isAnyItemSelected
//                     ? Container(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: _itemSelected!,
//                 )
//                     : Padding(
//                   padding:
//                   const EdgeInsets.only(left: 4.0), // change it here
//                   child: Text(
//                     widget.hintText,
//                     maxLines: 1,
//                     overflow: TextOverflow.clip,
//                   ),
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_drop_down,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Decoration? _getDecoration() {
//     if (_isOpen && !_isReverse) {
//       return BoxDecoration(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(widget.borderRadius),
//               topRight: Radius.circular(
//                 widget.borderRadius,
//               )));
//     } else if (_isOpen && _isReverse) {
//       return BoxDecoration(
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(widget.borderRadius),
//               bottomRight: Radius.circular(
//                 widget.borderRadius,
//               )));
//     } else if (!_isOpen) {
//       return BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)));
//     }
//     return null;
//   }
// }