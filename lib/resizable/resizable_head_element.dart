import 'package:flutter/material.dart';

class ResizableHeadElement extends StatefulWidget {
  const ResizableHeadElement({
    Key? key,
    required this.text,
    this.initialWidth = 100,
    this.minWidth = 100,
    this.maxWidth = 200,
    this.onWidthUpdate,
    this.isSHowDragElement = true,
    this.onWidthUpdateFinish,
    this.textPadding = 8,
    required this.isEnable,
  }) : super(key: key);

  final bool isEnable;
  final String text;
  final double textPadding;
  final double? initialWidth;
  final double minWidth;
  final double maxWidth;
  final void Function(double newWidth)? onWidthUpdate;
  final void Function()? onWidthUpdateFinish;
  final bool isSHowDragElement;
  @override
  State<ResizableHeadElement> createState() => _ResizableHeadElementState();
}

class _ResizableHeadElementState extends State<ResizableHeadElement> {
  @override
  void initState() {
    super.initState();
    width = widget.initialWidth ?? (widget.maxWidth + widget.minWidth) / 2;
  }

  late double width;
  bool onEnter = false;
  bool onDrag = false;
  @override
  Widget build(BuildContext context) {
    if (!widget.isEnable) return Container();
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
      ),
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.textPadding),
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              onEnter: (v) {
                onEnter = false;
                // print('onEnter');
              },
              onExit: (v) {
                onEnter = false;
                // print('onExit');
              },
              child: GestureDetector(
                onHorizontalDragStart: (detail) {
                  setState(() {
                    onDrag = true;
                  });

                  // print(detail);
                },
                onHorizontalDragEnd: (detail) {
                  if (widget.onWidthUpdateFinish != null) {
                    widget.onWidthUpdateFinish!();
                  }
                  setState(() {
                    onDrag = false;
                  });
                },
                onHorizontalDragUpdate: (detail) {
                  double newValue = width + detail.delta.dx;
                  // print(newValue);
                  if (newValue < widget.maxWidth &&
                      newValue > widget.minWidth) {
                    setState(() => width = newValue);
                    if (widget.onWidthUpdate != null) {
                      widget.onWidthUpdate!(newValue);
                    }
                  }
                },
                child: Container(
                  width: widget.isSHowDragElement ? 3 : 0,
                  color: onDrag ? Colors.blue : Colors.blue.withAlpha(100),
                  height: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
