import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:tesflutter/blank_page.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/view/Menu.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  CustomText({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
      ),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}

class SubJudul extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  SubJudul({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? Colors.black,
      ),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}

class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}

// Color color = Color.fromARGB(255, 39, 178, 0);
Color colorDefaultAplikasi = const Color.fromARGB(255, 0, 170, 19);
Color colorIcon = Color.fromARGB(255, 0, 0, 0);
Color putih = Color.fromARGB(255, 255, 255, 255);
MaterialColor material = MaterialColorGenerator.from(colorDefaultAplikasi);
MaterialColor material_putih = MaterialColorGenerator.from(putih);
final ThemeData themeProfile = ThemeData(
  primarySwatch: material_putih,
);
final ThemeData themeSend = ThemeData(
  primarySwatch: material_putih,
);
Future transision_page(BuildContext context, Widget x) {
  return Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => x,
          transitionsBuilder:
              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500)));
}

Future transision_page_Delete(BuildContext context, Widget x) {
  Navigator.popUntil(context, (route) => false);
  return Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => x,
          transitionsBuilder:
              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500)));
}

Future transision_replacement(BuildContext context, Widget x) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => x,
          transitionsBuilder:
              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500)));
}

AppBar setAppBarDefault(String title) {
  return AppBar(
    title: SubJudul(
      text: title,
      textAlign: TextAlign.center,
    ),
  );
}

// Function to check if a string contains emoji characters
bool containsEmoji(String input) {
  // This is a simplified approach and may not cover all cases
  return input.codeUnits.any((unit) => unit > 0x7F);
}

Widget displayImageBytes(List<String> imagePaths) {
  return Column(
    children: imagePaths.map((path) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Image.memory(
          File(path).readAsBytesSync(),
          fit: BoxFit.cover,
        ),
      );
    }).toList(),
  );
}

Future<List<Uint8List>> getImagesBytes(List<String> imagePaths) async {
  List<Uint8List> imageBytes = [];

  for (var path in imagePaths) {
    File imageFile = File(path);
    Uint8List bytes = await imageFile.readAsBytes();
    imageBytes.add(bytes);
  }

  return imageBytes;
}

class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
              SizedBox(height: 5),
              Text(label, textAlign: TextAlign.start),
            ],
          ),
        ),
      ),
    );
  }
}

Future<PermissionStatus> getCameraPermission() async {
  // Check if we already have permission to use the camera
  var permissionStatus = await Permission.camera.status;

  // If we don't have permission, request it
  if (permissionStatus != PermissionStatus.granted) {
    await Permission.camera.request();
  }

  // Check the status of the permission
  permissionStatus = await Permission.camera.status;
  print("lsksks $permissionStatus");
  if (permissionStatus == PermissionStatus.granted) {
    // We have permission to use the camera
    print("Permission granted");
  } else {
    // We don't have permission to use the camera
    print("Permission denied");
    permissionStatus = PermissionStatus.denied;
  }
  return permissionStatus;
}

Future<PermissionStatus> getMediaPermission() async {
  // Check if we already have permission to use the camera
  var permissionStatus = await Permission.storage.status;

  // If we don't have permission, request it
  if (permissionStatus != PermissionStatus.granted) {
    await Permission.storage.request();
  }

  // Check the status of the permission
  permissionStatus = await Permission.storage.status;
  if (permissionStatus == PermissionStatus.granted) {
    // We have permission to use the camera
    print("Permission granted");
  } else {
    // We don't have permission to use the camera
    print("Permission denied");
    permissionStatus = PermissionStatus.denied;
  }
  return permissionStatus;
}

Future<String> moveAndRenameFile(String sourceFiles, String newName) async {
  File sourceFile = File(sourceFiles);
  String newFolderPath = '/data/data/com.example.tesflutter/cache/Profile/'; // Change to your desired folder path
  String newFileName = newName; // Change to your desired new filename
  String newFilePath = newFolderPath + newFileName;

  try {
    // Create the destination directory if it doesn't exist
    Directory(newFolderPath).createSync(recursive: true);

    // Move the file to the new folder
    await sourceFile.rename(newFilePath);

    print('File moved and renamed successfully');
    return newFilePath;
  } catch (e) {
    print('Error moving and renaming file: $e');
    return 'Error moving and renaming file: $e';
  }
}

String generateFileName(String fileName) {
  final xfiles = fileName.split('.');
  final temp = xfiles.sublist(0, xfiles.length - 1).join('_').replaceAll(RegExp(r'[^a-zA-Z0-9.]'), '_');
  final randomString = generateRandomString(5);
  final currentDate = DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '');
  return 'Profile-$currentDate-$randomString.${xfiles.last}';
}

String generateRandomString(int length) {
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

class NavBar extends StatefulWidget {
  final int currentIndex;
  final Profile profile;
  // final PageStorageKey key = PageStorageKey('NavBar');
  NavBar({
    Key? key,
    required this.currentIndex,
    required this.profile,
  }) : super(key: key);
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  late final Profile profile;
  late List _screens_1 = [];
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    profile = widget.profile;
    List<Widget> _widgetOptions = <Widget>[
      MyHomePage(
        profile: profile,
      ),
      BlankPage(
        profile: profile,
        namepage: "Promo",
        currentindex: 1,
      ),
      BlankPage(
        profile: profile,
        namepage: "Pesanan",
        currentindex: 2,
      ),
      BlankPage(
        profile: profile,
        namepage: "Chat",
        currentindex: 3,
      ),
    ];
    _screens_1 = _widgetOptions;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      transision_replacement(context, _screens_1[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        selectedItemColor: colorDefaultAplikasi,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: 'beranda',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.percent),
            label: 'Promo',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.format_list_bulleted_add),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ]);
  }
}

// final List<Widget> imageSliders = imgList
//     .map((item) => Container(
//           child: Container(
//             margin: EdgeInsets.all(5.0),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 child: Stack(
//                   children: <Widget>[
//                     Image.network(item, fit: BoxFit.cover, width: 500.0),
//                     Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color.fromARGB(200, 0, 0, 0),
//                               Color.fromARGB(0, 0, 0, 0)
//                             ],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 20.0),
//                         child: Text(
//                           'No. ${imgList.indexOf(item)} image',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//           ),
//         ))
//     .toList();
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
              margin: EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  item,
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                ],
              )),
        ))
    .toList();
final List<Widget> imgList = [
  Container(
    child: Row(children: [Icon(Icons.abc), Text("Gojek")]),
  ),
  Container(
    child: Row(children: [Icon(Icons.abc), Text("Gojek")]),
  ),
  Container(
    child: Row(children: [Icon(Icons.abc), Text("Gojek")]),
  ),
];
final List<String> imgList_Send = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
