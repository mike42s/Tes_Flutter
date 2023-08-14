import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/view/EditProfile.dart';
import 'package:tesflutter/view/login.dart';

class ProfileSetting extends StatefulWidget {
  final Profile profile;
  const ProfileSetting({super.key, required this.profile});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  late Profile profile;
  @override
  void initState() {
    profile = widget.profile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeProfile,
      child: Scaffold(
        appBar: AppBar(
          title: SubJudul(
            text: "Profileku",
            textAlign: TextAlign.center,
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                color: colorIcon,
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Log Out?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Are you sure delete all login data',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      //delete all login pref
                                      final profile =
                                          await ProfileManager.getProfile();

                                      if (profile != null) {
                                        // print('id: ${profile.id}');
                                        print('nama: ${profile.nama}');
                                        print('noktp: ${profile.noktp}');
                                        print(
                                            'fotodriver: ${profile.fotodriver}');
                                        print('password: ${profile.password}');
                                      } else {
                                        print('No profile found.');
                                      }
                                      await ProfileManager
                                          .deleteAllSharedPreferences();
                                      Navigator.popUntil(
                                          context, (route) => false);
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) =>
                                                  const Login(),
                                              transitionsBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
                                                  Widget child) {
                                                return FadeTransition(
                                                    opacity: animation,
                                                    child: child);
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 500)));
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        backgroundColor: putih,
        body: Column(
          children: [
            ListTile(
              leading: profile.fotodriver.isEmpty
                  ? Container(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage(
                          "assets/images/defaultProfile.png",
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                        File(profile.fotodriver),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SubJudul(
                    text: profile.nama,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomText(
                    text: "No KTP : ${profile.noktp}",
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ), // Set the background color of the star and text container to black
                            padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal:
                                    10), // Add padding to adjust the black background
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                CustomText(
                                  text: "Bos",
                                  color: Colors.white, // Set the text color
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: const Icon(
                      Icons.edit_sharp,
                      size: 25,
                    ),
                    onTap: () {
                      transision_page(
                          context,
                          UbahProfile(
                            profile: profile,
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
