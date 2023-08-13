import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeProfile,
      child: Scaffold(
        appBar: setAppBarDefault("Profileku"),
        backgroundColor: putih,
        body: Container(),
      ),
    );
  }
}
