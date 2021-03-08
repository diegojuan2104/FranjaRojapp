import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/components/grid_colors.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/components/stack_avatar.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/questionModel.dart';
import 'package:franja_rojapp/providers/data.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AvatarPage extends StatefulWidget {
  AvatarPage({Key key}) : super(key: key);

  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  final panelController = PanelController();
  GlobalKey imageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Data>(context);
    double sizeH = MediaQuery.of(context).size.height;
    double sizeW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
          alignment: Alignment.topLeft,
          child: SlidingUpPanel(
              //maxHeight: ,
              controller: panelController,
              panelBuilder: (scrollController) => builSlidingPanel(
                  scrollController: scrollController,
                  panelController: panelController,
                  prov: prov,
                  sizeH: sizeH,
                  sizeW: sizeW),
              body: Scaffold(
                  floatingActionButton: Icon(Icons.ac_unit),
                  /*appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {},
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () async {
                            RenderRepaintBoundary imageOb =
                                imageKey.currentContext.findRenderObject();
                            final image = await imageOb.toImage(pixelRatio: 5);
                            ByteData byteData = await image.toByteData(
                                format: ImageByteFormat.png);
                            final pngBytes = byteData.buffer.asUint8List();
                            /*Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageTaked(
                                    imageBytes: pngBytes,
                                  )));
                        },
                        color: Colors.red,*/
                          })
                    ],
                  ),*/
                  body: Container(
                      alignment: Alignment.topLeft,
                      child: stackForAvatar(context, prov)) //),
                  ))),
    );
  }

  Widget stackForAvatar(BuildContext context, final prov) {
    return RepaintBoundary(
        key: imageKey,
        child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height - 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: prov.getavColor, spreadRadius: 0.2),
                ],
                image: DecorationImage(
                  image: Image.asset('assets/images/avatar_empty.png').image,
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(prov.getavColor, BlendMode.color),
                )),
            child: StackAvatar()));
  }

  Widget builSlidingPanel(
      {@required ScrollController scrollController,
      @required PanelController panelController,
      Data prov,
      double sizeH,
      double sizeW}) {
    List lista = prov.getListTabs(s: scrollController);
    lista.add(TabWidgetColor(scrollController: scrollController));
    return DefaultTabController(
        length: 9,
        child: Scaffold(
            appBar: builTabBar(
                onClicked: panelController.open,
                prov: prov,
                sizeH: sizeH,
                sizeW: sizeW),
            body: TabBarView(children: lista)));
  }

  Widget builTabBar(
      {VoidCallback onClicked, Data prov, double sizeH, double sizeW}) {
    print(sizeW);
    return PreferredSize(
      preferredSize: Size.fromHeight(sizeH * Constants.TAB_BAR_SIZE),
      child: GestureDetector(
        onTap: onClicked,
        child: AppBar(
          actions: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // splash color
                  onTap: () async {
                    RenderRepaintBoundary imageOb =
                        imageKey.currentContext.findRenderObject();
                    final image = await imageOb.toImage(pixelRatio: 5);
                    ByteData byteData =
                        await image.toByteData(format: ImageByteFormat.png);
                    final pngBytes = byteData.buffer.asUint8List();
                    prov.setImg = pngBytes;
                    print("sisas $pngBytes");
                  }, // button pressed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // icon
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 2, 0),
                        child: Text("Guardar"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: Icon(
                          Icons.save_alt,
                          color: Colors.red,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          title: Icon(Icons.drag_handle),
          centerTitle: true,
          titleSpacing: sizeW * Constants.SPACING_BAR_SIZE,
          bottom: TabBar(isScrollable: true, tabs: prov.getListTabs()),
        ),
      ),
    );
  }
}
/*class Avatar extends StatefulWidget {
  Avatar({Key key}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
            backgroundColor: Colors.transparent,
          ),
          Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              textColor: Colors.white,
              onPressed: () async => _saveAvatar(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Guardar Avatar"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _saveAvatar() {
    DatabaseService().saveAvatarCreated(context, true);
  }

  //TEST
  
}*/
