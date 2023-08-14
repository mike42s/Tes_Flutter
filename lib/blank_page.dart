import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';

class BlankPage extends StatefulWidget {
  final int currentindex;
  final String namepage;
  final Profile profile;
  const BlankPage({
    super.key,
    required this.profile,
    required this.namepage,
    required this.currentindex,
  });

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  late Profile profile;
  late String namePage;
  late int currentIndex;
  @override
  void initState() {
    profile = widget.profile;
    namePage = widget.namepage;
    currentIndex = widget.currentindex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeProfile,
      child: Scaffold(
        bottomNavigationBar: NavBar(
          currentIndex: currentIndex,
          profile: profile,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SubJudul(
            text: namePage,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: putih,
        body: Center(
          child: SubJudul(
            text: namePage,
          ),
        ),
      ),
    );
  }
}
