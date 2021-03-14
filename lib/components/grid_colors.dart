import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:provider/provider.dart';

class TabWidgetColor extends StatelessWidget {
  const TabWidgetColor({Key key, @required this.scrollController})
      : super(key: key);
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Data>(context);
    return buildColumn(prov);
  }
}

Column buildColumn(Data prov) {
  final list = prov.colorList;
  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => ColorWidget(
                    color: list[index],
                    press: () {
                      prov.avColor(list[index]);
                    },
                  )),
        ),
      ),
    ],
  );
}

class ColorWidget extends StatelessWidget {
  final Function press;
  final Color color;
  const ColorWidget({Key key, @required this.press, @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: press,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 160,
              width: 165,
              child: Container(
                //height: 180,
                //width: 150,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: this.color, borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
