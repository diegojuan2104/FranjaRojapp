class AvatarP{
  String path;
  double top;
  double left;
  String type;

  @override
  String toString() {
  return " Path: $path top: $top left: $left id: $left ";
   }
  AvatarP({this.path,this.top = 10,this.left = 10,this.type});

}