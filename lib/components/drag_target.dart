
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:franja_rojapp/models/avatar_stack_part.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:provider/provider.dart';

class DragTargetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Data avatar_data =  Provider.of<Data>(context);
    return DragTarget(onWillAccept: (data) {
      return true;
    }, onAccept: (AvatarP data) {
      if (avatar_data.itemsList.length >= 1) {
        print(data.path);
        avatar_data.deleteFromList(data);
        avatar_data.changeSuccessDrop(true);
        avatar_data.changeAcceptedData(data);
      }
    }, builder: (context, List<AvatarP> cd, rd) {
      /*if (Provider.of<Data>(context).isSuccessDrop) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(child: Icon(Icons.accessible_outlined,size: context.watch<Data>().sizeTrash,),)
        );
      } else {*/
        return Container(child: ImageIcon(AssetImage('assets/icons/trash.png'),size: context.watch<Data>().sizeTrash,),);
      //}
    });
  }

  List<Widget> buildTargetList(AvatarP cardItem) {
    List<Widget> targetList = [];
    targetList.add(
      Container(
          height: 200.0,
          width: 200.0,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.red,
            child: Center(
                child: Text(
              'cardItem.content',
              style: TextStyle(fontSize: 25.0, color: Colors.white),
            )),
          ),
        ),
    );
    return targetList;
  }
}

