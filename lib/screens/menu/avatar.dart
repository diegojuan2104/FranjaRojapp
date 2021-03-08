import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/components/grid_colors.dart';
import 'package:franja_rojapp/components/main_appbar.dart';
import 'package:franja_rojapp/components/stack_avatar.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/providers/ProviderInfo.dart';
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
    final prov2 = Provider.of<ProviderInfo>(context);
    double sizeH = MediaQuery.of(context).size.height;
    double sizeW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
          alignment: Alignment.topLeft,
          child: SlidingUpPanel(
              backdropEnabled: true,
              //maxHeight: ,
              controller: panelController,
              panelBuilder: (scrollController) => builSlidingPanel(
                  scrollController: scrollController,
                  panelController: panelController,
                  prov: prov,
                  sizeH: sizeH,
                  sizeW: sizeW,
                  prov2: prov2
                  ),
              body: Scaffold(
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
                borderRadius: BorderRadius.circular(10),
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
      double sizeW,
      ProviderInfo prov2
      
      }) {
    List lista = prov.getListTabs(s: scrollController);
    lista.add(TabWidgetColor(scrollController: scrollController));
    return DefaultTabController(
        length: 9,
        child: Scaffold(
            appBar: buildTabBar(
                onClicked: panelController.close,
                prov: prov,
                sizeH: sizeH,
                sizeW: sizeW
                , prov2: prov2,
                ),
            body: TabBarView(children: lista)));
  }

  Widget buildTabBar(
      {VoidCallback onClicked, Data prov, double sizeH, double sizeW, ProviderInfo prov2}) {
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
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // splash color
                  onTap: () {
                    Constants.Dialog(context, "Mensaje",
                        "¿Está listo para guardar su nuevo avatar?", () async {
                      RenderRepaintBoundary imageOb =
                          imageKey.currentContext.findRenderObject();
                      final image = await imageOb.toImage(pixelRatio: 5);
                      ByteData byteData =
                          await image.toByteData(format: ImageByteFormat.png);
                      final pngBytes = byteData.buffer.asUint8List();
                      prov.setImg = pngBytes;
                     if(!prov2.currentProfile.avatar_created){
                      await DatabaseService().saveAvatarCreated(context, true);
                     }
                     
                      Navigator.pushNamed(context, '/home');
                    }, () {});
                  }, // button pressed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // icon
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 2, 0),
                        child: Text("Guardar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
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
