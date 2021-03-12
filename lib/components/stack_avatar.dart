import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/components/drag_target.dart';
import 'package:franja_rojapp/models/avatar_stack_part.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

class StackAvatar extends StatelessWidget {
  const StackAvatar({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<AvatarP> lista = Provider.of<Data>(context).itemsList;
    return Container(
      child: Stack(
        children: _getStackItems(lista, context),
      ),
    );
  }
}

List<Widget> _getStackItems(List<AvatarP> data, BuildContext context) {
  List<Widget> toRet = [];
  for (var i = 0; i < data.length; i++) {
    toRet.add(DraggablePart(i: i));
  }

  toRet.add(Container(
    alignment: Alignment.bottomCenter,
    child: DragTargetWidget(),
  ));
  return toRet;
}

class DraggablePart extends StatelessWidget {
  const DraggablePart({Key key, @required this.i}) : super(key: key);
  final i;
  @override
  Widget build(BuildContext context) {
    final item_data = Provider.of<Data>(context);
    final item = item_data.itemsList[i];
    final list_medidas = item_data.sizeAvatar()[item.type];
    return Container(
      child: Draggable(
        onDragStarted: () {
          item_data.sizeTrah = 80;
        },
        data: item,
        child: getContainer(item, list_medidas),
        feedback: getContainer(item, list_medidas),
        childWhenDragging: getContainer(item, list_medidas),
        onDragCompleted: () {},
        onDragEnd: (drag) {
          double off_y = drag.offset.dy;
          double off_x = drag.offset.dx;
          double top = item.top;
          double left = item.left;
          double w = MediaQuery.of(context).size.width;
          double maxX = w - 60 - list_medidas[0] * item.sizew;
          double h = MediaQuery.of(context).size.height;
          double maxY = h -
              h * Constants.TAB_BAR_SIZE -
              100 -
              list_medidas[1] * item.sizeh;
          final double offsetXYBR = 107.0;
          final double offsetXYTL = 30.0;
          item_data.sizeTrah = 0;
          item_data.setValueListTop(
              i, getPosition(top, off_y, h, offsetXYBR, maxY));
          item_data.setValueListLeft(
              i,
              getPosition(left, off_x, MediaQuery.of(context).size.width,
                  offsetXYTL, maxX));
        },
      ),
    );
  }
}

double getPosition(double value, double off, length, double c, double max) {
  if ((value + off - c) > max) {
    return max;
  } else if ((value + off - c) < 0.0) {
    return 0;
  } else {
    return value + off - c;
  }
}

Widget getContainer(item, list_medidas) {
  return Container(
      padding: EdgeInsets.only(top: item.top, left: item.left),
      child: SizedBox(
          width: list_medidas[0] * item.sizew,
          height: list_medidas[1] * item.sizeh,
          child: Image.asset(item.path, fit: BoxFit.fill)));
}
