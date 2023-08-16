import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Barang.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/modal/dbprovider_database.dart';
import 'package:tesflutter/view/Menu.dart';
import 'package:tesflutter/view/ProfileSetting.dart';

class InputData extends StatefulWidget {
  final Profile profile;

  //required set parameter from find my map
  final String? latitudea;
  final String? latitudeb;
  final String? longitudea;
  final String? longitudeb;
  final List<String>? fotoPengiriman;
  final String type;
  const InputData(
      {Key? key,
      required this.profile,
      this.latitudea,
      this.latitudeb,
      this.longitudea,
      this.longitudeb,
      this.fotoPengiriman,
      required this.type})
      : super(key: key);

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  late Profile _profile;
  String? _latitude;
  String? _longtitude;
  // late PengirimanBarangModal Pengiriman = PengirimanBarangModal(
  //     fotoPengirimanBarang: [],
  //     latitudeA: 0.00,
  //     longitudeA: 0.00,
  //     longitudeB: 0.00,
  //     latitudeB: 0.00,
  //     id: 0,
  //     selisihlokasi: '');
  // PengirimanBarangModal? Pengiriman;
//lokasi temp
  double? latitudeA;
  double? longitudeA;
  double? latitudeB;
  double? longitudeB;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeAController = TextEditingController();
  final TextEditingController latitudeBController = TextEditingController();
  final TextEditingController longitudeAController = TextEditingController();
  final TextEditingController longitudeBController = TextEditingController();
  final TextEditingController selisihLokasiController = TextEditingController(text: "Isi data lokasi terlebih dahulu");

  List<String>? fotoPengirimanBarang = [];

  String distanceKM(
    double latitudeA,
    double longitudeA,
    double latitudeB,
    double longitudeB,
  ) {
    double distanceInMeters = Geolocator.distanceBetween(
      latitudeA,
      longitudeA,
      latitudeB,
      longitudeB,
    );

    double distanceInKilometers = distanceInMeters / 1000;

    return '${distanceInKilometers.toStringAsFixed(2)}';
  }

  DisplaysFile(List<String> x, String type) {
    return Container(
      child: Column(
        children: List.generate(x.length, (index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "File $type ${index + 1} with name ${x[index].toString()}",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        print(File(x[index]));
                        File(x[index]).delete();
                        x.removeAt(index);
                      });
                    },
                    child: Icon(Icons.delete),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        }),
      ),
    );
  }

  String? latitudeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a latitude';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? longitudeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a longitude';
    }
    double parsedValue = double.tryParse(value) ?? double.nan;
    if (parsedValue.isNaN || (parsedValue < -180.0 || parsedValue > 180.0)) {
      return 'Please enter a valid longitude between -180 and 180';
    }
    return null;
  }

  late Future<Position> _getPositionStream;
  @override
  void initState() {
    super.initState();
    // _initState();
    _getPositionStream = _getPositionStreamWithSettings();
    _profile = widget.profile;
    nameController.text = _profile.nama.toString();
    if (widget.latitudea != "" && widget.latitudea != null) {
      latitudeAController.text = widget.latitudea.toString();
    }
    if (widget.longitudea != "" && widget.longitudea != null) {
      longitudeAController.text = widget.longitudea.toString();
    }
    if (widget.latitudeb != "" && widget.latitudeb != null) {
      latitudeBController.text = widget.latitudeb.toString();
    }
    if (widget.longitudeb != "" && widget.longitudeb != null) {
      longitudeBController.text = widget.longitudeb.toString();
    }
    if (widget.fotoPengiriman != "" && widget.fotoPengiriman != null) {
      fotoPengirimanBarang = widget.fotoPengiriman;
    }
  }

  Future<Position> _getPositionStreamWithSettings() async {
    final locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
    final position = await Geolocator.getPositionStream(locationSettings: locationSettings)
        .first; // Using `.first` to get the first position from the stream
    setState(() {
      _latitude = position.latitude.toString();
      _longtitude = position.longitude.toString();
    });
    print("position stream : " + position.toString());
    return position;
  }

  Future<void> _initState() async {
    print("Hello");
    await _getPositionStreamWithSettings();

    // LocationPermission permission = await Geolocator.requestPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SubJudul(
          text: "Pengiriman Barang Form",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Same radius as the Container
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  PengirimanBarangModal x = PengirimanBarangModal(
                    id: 1,
                    fotoPengirimanBarang: fotoPengirimanBarang ?? [],
                    latitudeA: double.parse(latitudeAController.text.toString()),
                    latitudeB: double.parse(latitudeBController.text.toString()),
                    longitudeA: double.parse(longitudeAController.text.toString()),
                    longitudeB: double.parse(longitudeBController.text.toString()),
                    selisihlokasi: double.parse(selisihLokasiController.text.toString()),
                    createdat: DateTime.now(),
                    noktpdriver: _profile.noktp,
                  );
                  print(x.toJson().toString());
                  final result = DBProvider.db.saveBarang(x);
                  final snackBar = SnackBar(
                    content: Text("Oke, Sudah disave"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  transision_page_Delete(context, MyHomePage(profile: _profile));
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
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              widget.type == "new"
                  ? FutureBuilder<Position>(
                      future: _getPositionStream,
                      builder: (context, snapshot) {
                        print(snapshot.toString());
                        if (snapshot.hasData) {
                          _latitude = snapshot.data!.latitude.toString();
                          _longtitude = snapshot.data!.longitude.toString();
                          latitudeAController.text = _latitude ?? "";
                          longitudeAController.text = _longtitude ?? "";
                          // return Center(
                          //   child: Text(
                          //       'Latitude: ${_latitude}, Longitude: ${_longtitude}'),
                          // );
                          return Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: SubJudul(text: "Profil Driver"),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    // autovalidateMode:
                                    // AutovalidateMode.onUserInteraction,
                                    // enabled: false,
                                    readOnly: true,
                                    controller: nameController,
                                    // keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Nama',
                                      // hintText: 'Enter Nama',
                                      prefixIcon: Icon(Icons.person),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an ID';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: SubJudul(text: "Foto Barang"),
                                  ),
                                  fotoPengirimanBarang == null || fotoPengirimanBarang!.isEmpty
                                      ? Center(child: SubJudul(text: "Foto tidak ada"))
                                      // : DisplaysFile(fotoPengirimanBarang!, "Image"),
                                      : Container(
                                          child: CarouselSlider(
                                          options: CarouselOptions(
                                            aspectRatio: 2.0,
                                            enlargeCenterPage: true,
                                            enableInfiniteScroll: false,
                                            initialPage: 2,
                                            autoPlay: true,
                                          ),
                                          items: fotoPengirimanBarang!
                                              .map((item) => Container(
                                                    child: Container(
                                                      margin: EdgeInsets.all(5.0),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                          child: Stack(
                                                            children: <Widget>[
                                                              // Image.network(item,
                                                              //     fit: BoxFit.cover, width: 1000.0),
                                                              Image.file(
                                                                File(item),
                                                                width: 400,
                                                                height: 400,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              Positioned(
                                                                bottom: 0.0,
                                                                left: 0.0,
                                                                right: 0.0,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      colors: [
                                                                        Color.fromARGB(200, 0, 0, 0),
                                                                        Color.fromARGB(0, 0, 0, 0)
                                                                      ],
                                                                      begin: Alignment.bottomCenter,
                                                                      end: Alignment.topCenter,
                                                                    ),
                                                                  ),
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical: 10.0, horizontal: 20.0),
                                                                  child: Text(
                                                                    // 'No. ${imgList.indexOf(item)} image',
                                                                    'No. ${fotoPengirimanBarang!.indexOf(item) + 1} image',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 20.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ))
                                              .toList(),
                                        )),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MenuButton(
                                            label: 'Camera',
                                            icon: Icons.camera_alt,
                                            onPressed: () async {
                                              final statusX = await getCameraPermission();
                                              print("Final Status = $statusX");
                                              if (statusX.isGranted) {
                                                final picker = ImagePicker();
                                                XFile? pickedFile = await picker.pickImage(
                                                  source: ImageSource.camera,
                                                  preferredCameraDevice: CameraDevice.rear,
                                                );
                                                if (pickedFile != null) {
                                                  List<File> selectedFile = [];
                                                  selectedFile.add(File(pickedFile.path));
                                                  print(selectedFile);
                                                  final x = await moveAndRenameFile(
                                                      selectedFile[0].path, generateFileName(selectedFile[0].path));
                                                  print("Result after Moving : " + x.toString());
                                                  // _profile.fotodriver = x;
                                                  setState(() {
                                                    fotoPengirimanBarang!.add(x);
                                                    print("Final Barang : " + fotoPengirimanBarang!.toString());
                                                  });
                                                } else {
                                                  print("error");
                                                }
                                              } else {
                                                print("Error for request permission camera");
                                              }
                                            }),
                                      ),
                                      Expanded(
                                        child: MenuButton(
                                          label: 'Gallery',
                                          icon: Icons.photo,
                                          onPressed: () async {
                                            print("Form Pengiriman Barang ll !");
                                            final statusX = await getMediaPermission();
                                            print("Final Status = $statusX");
                                            if (statusX.isGranted) {
                                              // final picker =
                                              //     ImagePicker();
                                              // XFile? pickedFile =
                                              //     await picker
                                              //         .pickImage(
                                              //   source:
                                              //       ImageSource.gallery,
                                              // );
                                              // if (pickedFile != null) {
                                              //   File selectedFile =
                                              //       File(pickedFile
                                              //           .path);
                                              //   print(selectedFile);
                                              // final x =
                                              //     await moveAndRenameFile(
                                              //         selectedFile
                                              //             .path,
                                              //         generateFileName(
                                              //             selectedFile
                                              //                 .path));
                                              // print(
                                              //     "Result after Moving : " +
                                              //         x.toString());
                                              //   _profile.fotodriver = x;
                                              //   setState(() {
                                              //     Navigator.pop(
                                              //         context);
                                              //   });
                                              FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                                                allowMultiple: true,
                                                type: FileType.custom,
                                                allowedExtensions: ['jpg', 'png'],
                                              );
                                              if (pickedFile != null) {
                                                // List<String> files = [];
                                                for (int i = 0; i < pickedFile.files.length; i++) {
                                                  File selectedFile = File(pickedFile.files[i].path.toString());
                                                  print(selectedFile);
                                                  final x = await moveAndRenameFile(
                                                      selectedFile.path, generateFileName(selectedFile.path));
                                                  // files.add(x);
                                                  fotoPengirimanBarang!.add(x);
                                                }
                                                // _profile.fotodriver = files.toString();
                                                // final y = _profile.fotodriver.split(',');
                                                print("Final Barang : " + fotoPengirimanBarang.toString());
                                                setState(() {});
                                              } else {
                                                print("error");
                                              }
                                            } else {
                                              print("Error for request permission camera");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: SubJudul(text: "Lokasi Driver"),
                                  ),
                                  SizedBox(height: 16.0),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  controller: latitudeAController,
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText: 'Latitude A',
                                                    hintText: 'Enter latitude for point A',
                                                    prefixIcon: Icon(Icons.location_on),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorStyle: TextStyle(color: Colors.red),
                                                  ),
                                                  validator: latitudeValidator,
                                                ),
                                                SizedBox(height: 16.0),
                                                TextFormField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  controller: longitudeAController,
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText: 'Longitude A',
                                                    hintText: 'Enter longitude for point A',
                                                    prefixIcon: Icon(Icons.location_on),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorStyle: TextStyle(color: Colors.red),
                                                  ),
                                                  validator: longitudeValidator,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle button press
                                              transision_page(
                                                  context,
                                                  MapScreen(
                                                    Latitude: latitudeAController.text,
                                                    Longtitude: longitudeAController.text,
                                                    LongtitudeTemp: longitudeBController.text,
                                                    LatitudeTemp: latitudeBController.text,
                                                    profile: _profile,
                                                    fotoPengiriman: fotoPengirimanBarang,
                                                    type: "A",
                                                  ));
                                            },
                                            child: Text('Find On Map'),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.0),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: SubJudul(text: "Lokasi Kantor"),
                                  ),
                                  SizedBox(height: 16.0),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  controller: latitudeBController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: 'Latitude B',
                                                    hintText: 'Enter latitude for point B',
                                                    prefixIcon: Icon(Icons.location_on),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorStyle: TextStyle(color: Colors.red),
                                                  ),
                                                  validator: latitudeValidator,
                                                ),
                                                SizedBox(height: 16.0),
                                                TextFormField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  controller: longitudeBController,
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText: 'Longitude B',
                                                    hintText: 'Enter longitude for point B',
                                                    prefixIcon: Icon(Icons.location_on),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    errorStyle: TextStyle(color: Colors.red),
                                                  ),
                                                  validator: longitudeValidator,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle button press
                                              transision_page(
                                                  context,
                                                  MapScreen(
                                                    Latitude: latitudeBController.text,
                                                    Longtitude: longitudeBController.text,
                                                    profile: _profile,
                                                    LatitudeTemp: latitudeAController.text,
                                                    LongtitudeTemp: longitudeAController.text,
                                                    fotoPengiriman: fotoPengirimanBarang,
                                                    type: "B",
                                                  ));
                                            },
                                            child: Text('Find On Map'),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.0),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    readOnly: true,
                                    // enabled: false,
                                    // initialValue: "155.00",
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: selisihLokasiController,
                                    decoration: InputDecoration(
                                      labelText: 'Selisih Lokasi',
                                      hintText: 'Enter selisih lokasi',
                                      prefixIcon: Icon(Icons.compare_arrows),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the selisih lokasi';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Create and process the form data
                                        // ...

                                        setState(() {
                                          selisihLokasiController.text = distanceKM(
                                            double.parse(latitudeAController.text.toString()),
                                            double.parse(longitudeAController.text.toString()),
                                            double.parse(latitudeBController.text.toString()),
                                            double.parse(longitudeBController.text.toString()),
                                          );
                                          String message =
                                              "Data udah dihitung. Selisih lokasi : ${selisihLokasiController.text.toString()}";
                                          final snackBar = SnackBar(
                                            content: Text(message),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        });
                                      } else {
                                        String message = "Periksa Inputan Lokasi";
                                        final snackBar = SnackBar(
                                          content: Text(message),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    },
                                    child: Text('Calculate the distance'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: SubJudul(text: "Profil Driver"),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              // autovalidateMode:
                              // AutovalidateMode.onUserInteraction,
                              // enabled: false,
                              readOnly: true,
                              controller: nameController,
                              // keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Nama',
                                // hintText: 'Enter Nama',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorStyle: TextStyle(color: Colors.red),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an ID';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: SubJudul(text: "Foto Barang"),
                            ),
                            fotoPengirimanBarang == null || fotoPengirimanBarang!.isEmpty
                                ? Center(child: SubJudul(text: "Foto tidak ada"))
                                // : DisplaysFile(fotoPengirimanBarang!, "Image"),
                                : Container(
                                    child: CarouselSlider(
                                    options: CarouselOptions(
                                      aspectRatio: 2.0,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      initialPage: 2,
                                      autoPlay: true,
                                    ),
                                    items: fotoPengirimanBarang!
                                        .map((item) => Container(
                                              child: Container(
                                                margin: EdgeInsets.all(5.0),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        // Image.network(item,
                                                        //     fit: BoxFit.cover, width: 1000.0),
                                                        Image.file(
                                                          File(item),
                                                          width: 400,
                                                          height: 400,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Positioned(
                                                          bottom: 0.0,
                                                          left: 0.0,
                                                          right: 0.0,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  Color.fromARGB(200, 0, 0, 0),
                                                                  Color.fromARGB(0, 0, 0, 0)
                                                                ],
                                                                begin: Alignment.bottomCenter,
                                                                end: Alignment.topCenter,
                                                              ),
                                                            ),
                                                            padding:
                                                                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                            child: Text(
                                                              // 'No. ${imgList.indexOf(item)} image',
                                                              'No. ${_profile.fotodriver.split(',').indexOf(item) + 1} image',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 20.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ))
                                        .toList(),
                                  )),
                            Row(
                              children: [
                                Expanded(
                                  child: MenuButton(
                                      label: 'Camera',
                                      icon: Icons.camera_alt,
                                      onPressed: () async {
                                        final statusX = await getCameraPermission();
                                        print("Final Status = $statusX");
                                        if (statusX.isGranted) {
                                          final picker = ImagePicker();
                                          XFile? pickedFile = await picker.pickImage(
                                            source: ImageSource.camera,
                                            preferredCameraDevice: CameraDevice.rear,
                                          );
                                          if (pickedFile != null) {
                                            List<File> selectedFile = [];
                                            selectedFile.add(File(pickedFile.path));
                                            print(selectedFile);
                                            final x = await moveAndRenameFile(
                                                selectedFile[0].path, generateFileName(selectedFile[0].path));
                                            print("Result after Moving : " + x.toString());
                                            // _profile.fotodriver = x;
                                            setState(() {
                                              fotoPengirimanBarang!.add(x);
                                              print("Final Barang : " + fotoPengirimanBarang!.toString());
                                            });
                                          } else {
                                            print("error");
                                          }
                                        } else {
                                          print("Error for request permission camera");
                                        }
                                      }),
                                ),
                                Expanded(
                                  child: MenuButton(
                                    label: 'Gallery',
                                    icon: Icons.photo,
                                    onPressed: () async {
                                      final statusX = await getMediaPermission();
                                      print("Final Status = $statusX");
                                      if (statusX.isGranted) {
                                        // final picker =
                                        //     ImagePicker();
                                        // XFile? pickedFile =
                                        //     await picker
                                        //         .pickImage(
                                        //   source:
                                        //       ImageSource.gallery,
                                        // );
                                        // if (pickedFile != null) {
                                        //   File selectedFile =
                                        //       File(pickedFile
                                        //           .path);
                                        //   print(selectedFile);
                                        // final x =
                                        //     await moveAndRenameFile(
                                        //         selectedFile
                                        //             .path,
                                        //         generateFileName(
                                        //             selectedFile
                                        //                 .path));
                                        // print(
                                        //     "Result after Moving : " +
                                        //         x.toString());
                                        //   _profile.fotodriver = x;
                                        //   setState(() {
                                        //     Navigator.pop(
                                        //         context);
                                        //   });
                                        FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.custom,
                                          allowedExtensions: ['jpg', 'png'],
                                        );
                                        if (pickedFile != null) {
                                          // List<String> files = [];
                                          for (int i = 0; i < pickedFile.files.length; i++) {
                                            File selectedFile = File(pickedFile.files[i].path.toString());
                                            print(selectedFile);
                                            final x = await moveAndRenameFile(
                                                selectedFile.path, generateFileName(selectedFile.path));
                                            // files.add(x);
                                            fotoPengirimanBarang!.add(x);
                                          }
                                          // _profile.fotodriver = files.toString();
                                          // final y = _profile.fotodriver.split(',');
                                          print("Final Barang : " + fotoPengirimanBarang.toString());
                                          setState(() {});
                                        } else {
                                          print("error");
                                        }
                                      } else {
                                        print("Error for request permission camera");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: SubJudul(text: "Lokasi Driver"),
                            ),
                            SizedBox(height: 16.0),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            controller: latitudeAController,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                              labelText: 'Latitude A',
                                              hintText: 'Enter latitude for point A',
                                              prefixIcon: Icon(Icons.location_on),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorStyle: TextStyle(color: Colors.red),
                                            ),
                                            validator: latitudeValidator,
                                          ),
                                          SizedBox(height: 16.0),
                                          TextFormField(
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            controller: longitudeAController,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                              labelText: 'Longitude A',
                                              hintText: 'Enter longitude for point A',
                                              prefixIcon: Icon(Icons.location_on),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorStyle: TextStyle(color: Colors.red),
                                            ),
                                            validator: longitudeValidator,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button press
                                        transision_page(
                                            context,
                                            MapScreen(
                                              Latitude: latitudeAController.text,
                                              Longtitude: longitudeAController.text,
                                              LongtitudeTemp: longitudeBController.text,
                                              LatitudeTemp: latitudeBController.text,
                                              fotoPengiriman: fotoPengirimanBarang,
                                              profile: _profile,
                                              type: "A",
                                            ));
                                      },
                                      child: Text('Find On Map'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: SubJudul(text: "Lokasi Kantor"),
                            ),
                            SizedBox(height: 16.0),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            controller: latitudeBController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Latitude B',
                                              hintText: 'Enter latitude for point B',
                                              prefixIcon: Icon(Icons.location_on),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorStyle: TextStyle(color: Colors.red),
                                            ),
                                            validator: latitudeValidator,
                                          ),
                                          SizedBox(height: 16.0),
                                          TextFormField(
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            controller: longitudeBController,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                              labelText: 'Longitude B',
                                              hintText: 'Enter longitude for point B',
                                              prefixIcon: Icon(Icons.location_on),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              errorStyle: TextStyle(color: Colors.red),
                                            ),
                                            validator: longitudeValidator,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle button press
                                        transision_page(
                                            context,
                                            MapScreen(
                                              Latitude: latitudeBController.text,
                                              Longtitude: longitudeBController.text,
                                              profile: _profile,
                                              LatitudeTemp: latitudeAController.text,
                                              LongtitudeTemp: longitudeAController.text,
                                              fotoPengiriman: fotoPengirimanBarang,
                                              type: "B",
                                            ));
                                      },
                                      child: Text('Find On Map'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              readOnly: true,
                              // enabled: false,
                              // initialValue: "155.00",
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: selisihLokasiController,
                              decoration: InputDecoration(
                                labelText: 'Selisih Lokasi',
                                hintText: 'Enter selisih lokasi',
                                prefixIcon: Icon(Icons.compare_arrows),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorStyle: TextStyle(color: Colors.red),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the selisih lokasi';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Create and process the form data
                                  // ...

                                  setState(() {
                                    selisihLokasiController.text = distanceKM(
                                      double.parse(latitudeAController.text.toString()),
                                      double.parse(longitudeAController.text.toString()),
                                      double.parse(latitudeBController.text.toString()),
                                      double.parse(longitudeBController.text.toString()),
                                    );
                                    String message =
                                        "Data udah dihitung. Selisih lokasi : ${selisihLokasiController.text.toString()}";
                                    final snackBar = SnackBar(
                                      content: Text(message),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  });
                                } else {
                                  String message = "Periksa Inputan Lokasi";
                                  final snackBar = SnackBar(
                                    content: Text(message),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              child: Text('Calculate the distance'),
                            ),
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

class MapScreen extends StatefulWidget {
  final String? Latitude;
  final String? Longtitude;
  final String? LatitudeTemp;
  final String? LongtitudeTemp;
  final String? type;
  final Profile profile;
  final List<String>? fotoPengiriman;
  const MapScreen({
    Key? key,
    this.Latitude,
    this.Longtitude,
    this.type,
    required this.profile,
    this.LatitudeTemp,
    this.LongtitudeTemp,
    this.fotoPengiriman,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final Profile _profile;
  final MapController _mapController = MapController();
  Position? _currentPosition;
  double? _longitude;
  double? _latitude;
  String? type; //parameter for A / B
  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  void MoveMap(double _latitude, double _longitude) async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _mapController.move(LatLng(_latitude, _longitude), 15);
    });
  }

  Future<void> _initLocationService() async {
    LocationPermission permission = await Geolocator.requestPermission();
    type = widget.type ?? "";
    _profile = widget.profile;
    print("init location service");
    if (widget.Latitude != "" && widget.Longtitude != "") {
      // Position position = await Geolocator.getCurrentPosition();
      print("Masuk Katagori Bypassan: " + widget.Latitude! + " " + widget.Longtitude!);
      setState(() {
        _latitude = double.parse(widget.Latitude!);
        _longitude = double.parse(widget.Longtitude!);
        MoveMap(_latitude!, _longitude!);
        setState(() {
          markers.add(
            Marker(
              width: 45.0,
              height: 45.0,
              point: LatLng(_latitude!, _longitude!),
              builder: (context) => Container(
                child: Icon(Icons.location_on, color: Colors.red),
              ),
            ),
          );
        });
      });
    } else {
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        return;
      }
      LocationSettings x_setting = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
      Geolocator.getPositionStream(locationSettings: x_setting).listen((Position position) {
        setState(() {
          _currentPosition = position;
          _mapController.move(LatLng(position.latitude, position.longitude), 15);
        });
      });
    }
  }

  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,

      appBar: setAppBarDefault("Maps Flutter 5.0.0"),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9.2,
          onTap: (tapPosition, point) {
            print("You selected the point: ${tapPosition.toString()} and the point: ${point.toString()}");
            setState(() {
              markers.add(
                Marker(
                  width: 45.0,
                  height: 45.0,
                  point: point,
                  builder: (context) => Container(
                    child: Icon(Icons.location_on, color: Colors.red),
                  ),
                ),
              );
              if (type == "A") {
                final snackBar = SnackBar(
                  content: Text("Apakah kamu sudah yakin merubah lokasi driver ke titik ini?"),
                  action: SnackBarAction(
                    label: 'Ya',
                    onPressed: () {
                      transision_page(
                          context,
                          InputData(
                            profile: _profile,
                            latitudea: point.latitude.toString(),
                            longitudea: point.longitude.toString(),
                            longitudeb: widget.LongtitudeTemp,
                            latitudeb: widget.LatitudeTemp,
                            fotoPengiriman: widget.fotoPengiriman,
                            type: "old",
                          ));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (type == "B") {
                final snackBar = SnackBar(
                  content: Text("Apakah kamu sudah yakin merubah lokasi kantor ke titik ini?"),
                  action: SnackBarAction(
                    label: 'Ya',
                    onPressed: () {
                      transision_page(
                          context,
                          InputData(
                            profile: _profile,
                            latitudeb: point.latitude.toString(),
                            longitudeb: point.longitude.toString(),
                            longitudea: widget.LongtitudeTemp,
                            latitudea: widget.LatitudeTemp,
                            fotoPengiriman: widget.fotoPengiriman,
                            type: "old",
                          ));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            });
          },
        ),
        nonRotatedChildren: [
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors', onTap: () {}
                  // launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
            ],
          ),
        ],
        mapController: _mapController,
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          // PolygonLayer(
          //   polygons: [
          //     Polygon(
          //       points: [
          //         LatLng(-7.447044, 112.701334),
          //         LatLng(-7.445353, 112.704866),
          //         LatLng(-7.448095, 112.706294)
          //       ],
          //       color: Colors.blue,
          //       isFilled: true,
          //     ),
          //   ],
          // ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
      // The floating buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: Text("btn1"),
            onPressed: () async {
              // Get the user's current location
              LocationPermission permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                print('Location permission denied');
                return;
              }

              // Get the user's current position
              Position position = await Geolocator.getCurrentPosition();

              // Set the longitude and latitude values
              _longitude = position.longitude;
              _latitude = position.latitude;
              MoveMap(_latitude!, _longitude!);
              setState(() {
                markers.add(
                  Marker(
                    width: 45.0,
                    height: 45.0,
                    point: LatLng(position.latitude, position.longitude),
                    builder: (context) => Container(
                      child: Icon(Icons.location_on, color: Colors.red),
                    ),
                  ),
                );
              });
            },
            child: Icon(Icons.my_location),
          ),
          FloatingActionButton(
            heroTag: Text("btn2"),
            onPressed: () {
              // Show a dialog to allow the user to input their longitude and latitude
              TextEditingController longitudeController = TextEditingController();
              TextEditingController latitudeController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Select Location'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: longitudeController,
                          decoration: InputDecoration(labelText: 'Longitude'),
                        ),
                        TextField(
                          controller: latitudeController,
                          decoration: InputDecoration(labelText: 'Latitude'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Get the longitude and latitude values from the text fields
                          // _longitude = double.parse(longitudeController.text);
                          // _latitude = double.parse(latitudeController.text);
                          // _latitude = -7.4502;
                          // _longitude = 112.6952;
                          print("HALOOO");
                          print(_latitude);
                          print(_longitude);
                          // Close the dialog
                          MoveMap(_latitude!, _longitude!);
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.location_on),
          ),
        ],
      ),
    );
  }
}
