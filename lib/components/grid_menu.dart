import 'package:flutter/material.dart';

class GridMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color warna;
  final Function action;

  const GridMenu({Key key, this.title, this.icon, this.warna, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.white70, width: 1),
    borderRadius: BorderRadius.circular(15),
  ),
        child: InkWell(
          onTap: () {
            action();
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  size: 60,
                  color: warna,
                ),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                        fontStyle: FontStyle.normal))
              ],
            ),  
          ),
        ),
      ),
    );
  }
}