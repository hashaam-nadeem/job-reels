import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<CustomDropdownMenuItem> items;
  final ValueListenable<bool> ?isRemoveOverLayEntry;
  final ValueListenable<bool> ?isResetSelection;
  final Function(int index, dynamic value) onChanged;
  final Function()? onOpen;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double borderWidth;
  int defaultSelectedIndex;
  final bool enabled;
  final bool isMultiSelect;

  CustomDropDown({
    required this.items,
    required this.onChanged,
     this.onOpen,
    this.isRemoveOverLayEntry,
    this.isResetSelection,
    this.hintText = "",
    this.borderRadius = 0,
    this.borderWidth = 1,
    this.maxListHeight = 100,
    this.defaultSelectedIndex = -1,
    Key? key,
    this.enabled = true,
    this.isMultiSelect = false,
  })
  : super(key: key);

  @override
  CustomDropDownState createState() => CustomDropDownState();
}

class CustomDropDownState extends State<CustomDropDown>
    with WidgetsBindingObserver {
  bool _isOpen = false, _isAnyItemSelected = false, _isReverse = false;
  int selectedItemIndex = -1;
  late OverlayEntry _overlayEntry;
  late RenderBox? _renderBox;
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    selectedItemIndex = widget.defaultSelectedIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          dropDownOffset = getOffset();
        });
      }
      if (selectedItemIndex > -1) {
        if (selectedItemIndex < widget.items.length) {
          if (mounted) {
            setState(() {
              if(!widget.isMultiSelect){
                _isAnyItemSelected = true;
              }
              widget.onChanged(selectedItemIndex, widget.items[selectedItemIndex].value);
            });
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  void _addOverlay() async{
    if(widget.onOpen!=null){
      widget.onOpen!();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    if (mounted) {
      setState(() {
        _isOpen = true;
      });
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    try{
      if (mounted) {
        setState(() {
          _isOpen = false;
        });
        _overlayEntry.remove();
      }
    }catch(e){}
  }
  void _resetSelection() {
    try{
      if (mounted) {
        setState(() {
          _isAnyItemSelected = false;
        });
      }
    }catch(e){}
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    _renderBox = context.findRenderObject() as RenderBox?;

    var size = _renderBox!.size;

    dropDownOffset = getOffset();
    return OverlayEntry(
        maintainState: false,
        builder: (context) => Align(
          alignment: Alignment.center,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: dropDownOffset,
            child: SizedBox(
              height: widget.maxListHeight+10,
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: _isReverse
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: widget.maxListHeight, maxWidth: size.width),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius),
                        ),
                        child: Material(
                          elevation: 0,
                          shadowColor: Colors.grey,
                          child: Scrollbar(
                            controller: ScrollController(),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: widget.items.map((item) => InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                      child: item.child,
                                    ),
                                    const Divider(height: 1,thickness: 1,),
                                  ],
                                ),
                                onTap: () {
                                  if (mounted) {
                                    selectedItemIndex = widget.items.indexOf(item);
                                    if(!widget.isMultiSelect){
                                      _removeOverlay();
                                      _isAnyItemSelected = true;
                                    }
                                    widget.onChanged(selectedItemIndex, item.value);
                                    setState(() {});
                                  }
                                },
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Offset getOffset() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    double y = renderBox!.localToGlobal(Offset.zero).dy;
    double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
    if (spaceAvailable > widget.maxListHeight) {
      _isReverse = false;
      return Offset(0, renderBox.size.height);
    } else {
      _isReverse = true;
      return Offset(
          0,
          renderBox.size.height -
              (widget.maxListHeight + renderBox.size.height));
    }
  }

  double _getAvailableSpace(double offsetY) {
    double safePaddingTop = MediaQuery.of(context).padding.top;
    double safePaddingBottom = MediaQuery.of(context).padding.bottom;

    double screenHeight =
        MediaQuery.of(context).size.height - safePaddingBottom - safePaddingTop;

    return screenHeight - offsetY;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isRemoveOverLayEntry?.value??false){
      _removeOverlay();
    }
    if(widget.isResetSelection?.value??false){
      _resetSelection();
    }
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled
            ? () {
          _isOpen ? _removeOverlay() : _addOverlay();
        }
            : null,
        child: Container(
          decoration: _getDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: _isAnyItemSelected && !widget.isMultiSelect && selectedItemIndex > -1
                    ? Container(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: widget.items[selectedItemIndex],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 4.0), // change it here
                        child: Text(
                          widget.hintText,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration? _getDecoration() {
    if (_isOpen && !_isReverse) {
      return BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.borderRadius),
              topRight: Radius.circular(
                widget.borderRadius,
              )));
    } else if (_isOpen && _isReverse) {
      return BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadius),
              bottomRight: Radius.circular(
                widget.borderRadius,
              )));
    } else if (!_isOpen) {
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)));
    }
    return null;
  }
}

class CustomDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;
  CustomDropdownMenuItem({super.key, required this.value, required this.child,});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}