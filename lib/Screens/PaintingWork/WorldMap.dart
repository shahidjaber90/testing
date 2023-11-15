import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:http/http.dart' as http;

class WorldMap extends StatelessWidget {
  static Color? pickerColor;
  String artID;
  final notifier = ValueNotifier(Offset.zero);
  Map mArt;
  var finalpaths = [];
  WorldMap(
    this.mArt,
    this.artID,
  );

  getListPaths() {
    List pathList = mArt["image_path"];
    for (var path in pathList) {
      finalpaths.add(Shape(path["path"], Colors.white));
    }
    return finalpaths;
  }

  @override
  Widget build(BuildContext context) {
    var mPainter = WorldMapPainter(
        notifier,
        getListPaths(),
        Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.7),
        context,
        artID);
    return Stack(children: [
      Listener(
        onPointerDown: (e) => notifier.value = e.localPosition,
        onPointerMove: (e) => notifier.value = e.localPosition,
        child: CustomPaint(
          painter: mPainter,
          child: SizedBox.expand(),
        ),
      ),
      Positioned(
          right: 0,
          child: TextButton(
              onPressed: () async {
                mPainter.getImage();
              },
              child: Text("Save")))
    ]);
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
  Size picsize;
  BuildContext context;
  String artID;
  WorldMapPainter(
      this._notifier, this._shapes, this.picsize, this.context, this.artID)
      : super(repaint: _notifier);

  final ValueNotifier<Offset> _notifier;
  final Paint _paint = Paint();
  Size _size = Size.zero;

  getImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(
            Offset(0.0, 0.0), Offset(picsize.width, picsize.height)));
    canvas
      ..clipRect(Offset.zero & picsize)
      ..drawColor(ui.Color.fromARGB(255, 255, 255, 255), BlendMode.src);
    for (int i = 0; i < _shapes.length; i++) {
      var shape = _shapes[i];
      final path = shape._transformedPath;
      shape._color = shape._color;
      _shapes[i] = shape;
      _paint
        ..color = shape._color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, _paint);
      _paint
        ..color = Colors.black
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    }
    final picture = recorder.endRecording();
    final img = (await picture.toImage(200, 200));
    _saveImage(img);
  }

  File? imageFile;
  // upload image 2
  Future<void> uploadNetworkImage2(String artID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('userEmail').toString();
    String myToken = prefs.getString('getaccesToken').toString();
    print('userEmail: $userEmail');
    print('artID: $artID');
    print('artID: $imageFile');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://cv.glamouride.org/api/upload-art'),
      );

      // Add headers, including the access token
      request.headers['Authorization'] = 'Bearer $myToken';

      request.fields['email'] = userEmail;
      request.fields['art_id'] = artID;
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );

      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        String message = 'Image uploaded successfully';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstant.whiteColor,
            content: Text(
              message,
              style: TextStyle(
                color: ColorConstant.buttonColor2,
              ),
            ),
          ),
        );
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        String message = 'Failed to upload image. Status code';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstant.whiteColor,
            content: Text(
              message,
              style: TextStyle(
                color: ColorConstant.buttonColor2,
              ),
            ),
          ),
        );
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error Reasone is:: $e');
    }
  }

  Future<File> _saveImage(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData!.buffer.asUint8List();
    //New line added by sabeel
    showAlertDialog(context, Image.memory(byteData!.buffer.asUint8List()));
    //End line
    Directory tempDir = await getTemporaryDirectory();
    imageFile = File('${tempDir.path}/image.png');
    await imageFile!.writeAsBytes(pngBytes);
    return imageFile!;
  }

  showAlertDialog(BuildContext context, Image img) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        await uploadNetworkImage2(artID);
        Navigator.pop(context);
      },
    );
    Widget backButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: img,
      actions: [
        backButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
