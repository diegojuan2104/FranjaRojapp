import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:franja_rojapp/models/avatar_grid_part.dart';
import 'package:franja_rojapp/models/avatar_stack_part.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:provider/provider.dart';

class TabWidget extends StatelessWidget {
  const TabWidget(
      {Key key, @required this.scrollController, @required this.parameter})
      : super(key: key);
  final ScrollController scrollController;
  final String parameter;
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Data>(context);
    return buildColumn(prov, parameter);
  }
}


Column buildColumn(Data prov, String parameter) {
  final list = prov.mapItems[parameter];
  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20,20),
          child: GridView.builder(
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => AvatarCard(
                    avatar: list[index],
                    press: () {
                      final canI = prov.validateFranjas(list[index]);
                      if (canI) {
                        final av =
                            AvatarP(path: list[index].image, type: parameter);
                        prov.addElementList(av);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  title: Text("necesitas más franjas"),
                                ));
                      }
                    },
                  )),
        ),
      ),
    ],
  );
}

class AvatarCard extends StatelessWidget {
  final AvatarModel avatar;
  final Function press;
  const AvatarCard({Key key, @required this.avatar, @required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: press,
          child: SizedBox(
            height: 160,
            width: 165,
            child: Container(
              //height: 180,
              //width: 150,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFfC2c2C)),
                  color: avatar.color, borderRadius: BorderRadius.circular(16)),
              child: Image.asset(avatar.image),
            ),
          ),
        ),
      ],
    );
  }
}
