import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class WorldMap extends StatelessWidget {
  static Color? pickerColor;
  final notifier = ValueNotifier(Offset.zero);
  Map mArt;
  var finalpaths=[];
  WorldMap(this.mArt);

   getListPaths(){
    List pathList=mArt["image_path"];
    for(var path in pathList){
        finalpaths.add(Shape(path["path"], Colors.white));
    }
    return finalpaths;
   }


  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) => notifier.value = e.localPosition,
      onPointerMove: (e) => notifier.value = e.localPosition,
      child: CustomPaint(
        painter: WorldMapPainter(notifier,getListPaths()),
        child: SizedBox.expand(),
      ),
    );
  }
}

class Shape {
  Shape(strPath, this._color) : _path = parseSvgPath(strPath);

  /// transforms a [_path] into [_transformedPath] using given [matrix]
  void transform(Matrix4 matrix) =>
      _transformedPath = _path.transform(matrix.storage);

  Path _path;
  Path? _transformedPath;
  Color _color;
}

class WorldMapPainter extends CustomPainter {
  var _shapes = [];
  WorldMapPainter(this._notifier,this._shapes) : super(repaint: _notifier);

  

  final ValueNotifier<Offset> _notifier;
  final Paint _paint = Paint();
  Size _size = Size.zero;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, Size(423.22101, 423.22101), size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      for (var shape in _shapes) {
        shape.transform(matrix);
      }
      print('new size: $_size');
    }

    canvas
      ..clipRect(Offset.zero & size)
      ..drawColor(ui.Color.fromARGB(255, 255, 255, 255), BlendMode.src);
    var selectedShape;
    for (int i = 0; i < _shapes.length; i++) {
      var shape = _shapes[i];
      final path = shape._transformedPath;
      var selected = path!.contains(_notifier.value);
      if (selected) {
        shape._color = WorldMap.pickerColor ?? shape._color;
        _shapes[i] = shape;
        selected = false;
      }
      _paint
        ..color = shape._color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, _paint);
      selectedShape ??= selected ? shape : null;

      _paint
        ..color = Colors.black
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    }
    if (selectedShape != null) {}
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
