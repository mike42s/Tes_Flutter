import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';

import 'package:image_picker/image_picker.dart';
import 'package:tesflutter/modal/dbprovider_database.dart';

class BuatProfile extends StatefulWidget {
  const BuatProfile({
    super.key,
  });

  @override
  State<BuatProfile> createState() => _BuatProfileState();
}

class _BuatProfileState extends State<BuatProfile> {
  final _formKey = GlobalKey<FormState>();
  late Profile _profile;

  @override
  void initState() {
    super.initState();
    // _profile = DBProvider.db.getData();

    //debug mode
    // _profile = Profile(
    //     nama: 'A1',
    //     noktp: '1234567890123456',
    //     fotodriver: '',
    //     password: '12345678');
    _profile = Profile(nama: '', noktp: '', fotodriver: '', password: '');
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // You can now use _profile to save the data or send it to an API
        print("Data saved: ${_profile.toJson()}");
        final result = await DBProvider.db.saveData(_profile);
        setState(() {
          print("Result : " + result.toString());

          // if( )
          final x = ProfileManager.saveProfile(_profile);
          final snackBar = SnackBar(
            content: Text("The Form has been saved, Your Account was saved"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        });
      } catch (e) {
        final snackBar = SnackBar(
          content:
              Text("An error occurred while fetching data from the database"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeProfile,
      child: Scaffold(
        appBar: AppBar(
          title: SubJudul(
            text: "Create Profile",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        40), // Same radius as the Container
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _saveForm();
                  } else {
                    print("Error");
                    final snackBar = SnackBar(
                      content: Text("Check Again Error the Form"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: CustomText(
                  text: "SIMPAN",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: putih,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: "Foto profil",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _profile.fotodriver.isEmpty
                                  ? Container(
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AssetImage(
                                          "assets/images/defaultProfile.png",
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.file(
                                        File(_profile.fotodriver),
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              CustomText(
                                text: "Tambah Foto",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          onTap: () {
                            print("Tambah Foto");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Ganti foto Profil'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MenuButton(
                                          label: 'Camera',
                                          icon: Icons.camera_alt,
                                          onPressed: () async {
                                            final statusX =
                                                await getCameraPermission();
                                            print("Final Status = $statusX");
                                            if (statusX.isGranted) {
                                              final picker = ImagePicker();
                                              XFile? pickedFile =
                                                  await picker.pickImage(
                                                source: ImageSource.camera,
                                                preferredCameraDevice:
                                                    CameraDevice.front,
                                              );
                                              if (pickedFile != null) {
                                                File selectedFile =
                                                    File(pickedFile.path);
                                                print(selectedFile);
                                                final x =
                                                    await moveAndRenameFile(
                                                        selectedFile.path,
                                                        generateFileName(
                                                            selectedFile.path));
                                                print("Result after Moving : " +
                                                    x.toString());
                                                _profile.fotodriver = x;
                                                Navigator.pop(context);
                                              } else {
                                                print("error");
                                              }
                                            } else {
                                              print(
                                                  "Error for request permission camera");
                                            }
                                          }),
                                      MenuButton(
                                        label: 'Gallery',
                                        icon: Icons.photo,
                                        onPressed: () async {
                                          final statusX =
                                              await getMediaPermission();
                                          print("Final Status = $statusX");
                                          if (statusX.isGranted) {
                                            final picker = ImagePicker();
                                            XFile? pickedFile =
                                                await picker.pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            if (pickedFile != null) {
                                              File selectedFile =
                                                  File(pickedFile.path);
                                              print(selectedFile);
                                              final x = await moveAndRenameFile(
                                                  selectedFile.path,
                                                  generateFileName(
                                                      selectedFile.path));
                                              print("Result after Moving : " +
                                                  x.toString());
                                              _profile.fotodriver = x;
                                              Navigator.pop(context);
                                            } else {
                                              print("error");
                                            }
                                          } else {
                                            print(
                                                "Error for request permission camera");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: CustomText(
                      text:
                          "Pasang Foto yang oke! Semua orang bakal bisa lihat.",
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Nama",
                            textAlign: TextAlign.center,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.red,
                            size: 10,
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _profile.nama,
                        decoration: InputDecoration(
                          hintText: "Huruf alfabet, tanpa emoji/simbol",
                        ),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama is required';
                          }

                          final alphabeticPattern = RegExp(
                              r'^[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)*$'); // Allows only alphabetic characters and number and spaces

                          if (!alphabeticPattern.hasMatch(value)) {
                            return 'Input must contain alphabetic characters only';
                          }

                          if (value.length < 2 || value.length > 30) {
                            return 'Input must be between 2 and 30 characters';
                          }

                          return null; // Input is valid
                        },
                        onSaved: (value) {
                          _profile.nama = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "No KTP",
                            textAlign: TextAlign.center,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.red,
                            size: 10,
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _profile.noktp,
                        decoration: InputDecoration(
                          hintText: "Angka",
                        ),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No KTP is required';
                          }

                          final alphabeticPattern =
                              RegExp(r'^[0-9]*$'); // Allows only number

                          if (!alphabeticPattern.hasMatch(value)) {
                            return 'Input must contain numbers only';
                          }

                          if (value.length < 16 || value.length > 16) {
                            return 'Input must be 16 characters';
                          }

                          return null; // Input is valid
                        },
                        onSaved: (value) {
                          _profile.noktp = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Password",
                            textAlign: TextAlign.center,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.red,
                            size: 10,
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _profile.password,
                        decoration: InputDecoration(
                          hintText: "Kombinasi selain emoji",
                        ),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }

                          final passwordPattern = RegExp(
                              r'^[!-~]+$'); // Allows only ASCII characters (range: 32-126)

                          if (!passwordPattern.hasMatch(value)) {
                            return 'Input must only contain ASCII characters (range: 32-126)';
                          }

                          if (value.length < 8 || value.length > 16) {
                            return 'Input must be between 8 and 16 characters';
                          }

                          return null; // Input is valid
                        },
                        onSaved: (value) {
                          _profile.password = value!;
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
