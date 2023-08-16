import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Barang.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/modal/dbprovider_database.dart';
import 'package:intl/intl.dart';
import 'package:tesflutter/view/FormPengirimanBarang.dart';
import 'package:path/path.dart';

class HistoryListPage extends StatefulWidget {
  final Profile profile;

  HistoryListPage({required this.profile});

  @override
  _HistoryListPageState createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  late Profile _profile;
  late Future<List<PengirimanBarangModal>> historyBarangList;
  List<PengirimanBarangModal> filteredList = [];
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();

    _profile = widget.profile;
    historyBarangList = DBProvider.db.getDataBarang(_profile.noktp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppBarDefault("History Pengiriman Barang"),
      body: FutureBuilder<List<PengirimanBarangModal>>(
        future: historyBarangList, // Replace with the function that returns the Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final x = snapshot.data!;
            // print(x.toString());
            for (int i = 0; i < x.length; i++) {
              print(x[i].toJson().toString());
            }
            // filteredList = x;

            // Filter the history goods by a specific date (e.g., 15th of August)
            // DateTime targetDate = DateTime(2023, 8, 15); // Replace with your desired date
            // List<PengirimanBarangModal> filteredList = x
            //     .where((item) =>
            //         item.createdat.year == targetDate.year &&
            //         item.createdat.month == targetDate.month &&
            //         item.createdat.day == targetDate.day)
            //     .toList();

            // return ListView.builder(
            //   itemCount: filteredList.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(
            //           'History Barang ID: ${DateFormat('dd/MM/yyyy hh:mm:s').format((filteredList[index].createdat))}'),
            // onTap: () {
            //   transision_page(
            //     context,
            //     HistoryDetailPage(
            //       historyBarang: filteredList[index],
            //       profile: _profile,
            //     ),
            //   );
            // },
            //     );
            //   },
            // );
            // filteredList = x.where((element) => element.createdat.day == selectedDate.day).toList();
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    filteredList.isEmpty
                        ? SubJudul(text: "Belum Tersortir berdasarkan tanggal")
                        : Expanded(
                            child: SubJudul(
                                textAlign: TextAlign.center,
                                text:
                                    "Tersortir tgl (dd/MM/yyyy) ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")),
                    Calendar(
                      selectedDate: selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                          filteredList = x.where((element) => element.createdat.day == selectedDate.day).toList();
                        });
                      },
                    ),
                  ],
                ),
                x.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: filteredList.isNotEmpty ? filteredList.length : x.length,
                          itemBuilder: (context, index) {
                            final data = filteredList.isNotEmpty ? filteredList[index] : x[index];
                            return ListTile(
                              title: Text(
                                'History Barang Date: ${DateFormat('dd/MM/yyyy hh:mm:s').format(data.createdat)}',
                              ),
                              onTap: () {
                                transision_page(
                                  context,
                                  HistoryDetailPage(
                                    historyBarang: data,
                                    profile: _profile,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Center(child: SubJudul(text: 'No Data')),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const Calendar({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your calendar widget here
    // Return a button or a picker for selecting the date
    return ElevatedButton(
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        ).then((pickedDate) {
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        });
      },
      child: Text('Select Date'),
    );
  }
}

class HistoryDetailPage extends StatelessWidget {
  final PengirimanBarangModal historyBarang;
  final Profile profile;

  HistoryDetailPage({
    required this.historyBarang,
    required this.profile,
  });
  List<String> fotoPengirimanBarangList() {
    // Convert the stored string back to a list of strings
    return historyBarang.fotoPengirimanBarang;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History Goods Detail')),
      body: SingleChildScrollView(
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     // Display other details like id, latitude, longitude, selisihlokasi here
        //     Text('History Goods ID: ${historyBarang.id}'),
        //     Text('History createdat: ${historyBarang.createdat}'),
        //     Text('History Goods noktpdriver: ${historyBarang.noktpdriver}'),
        //     // Display images
        //     // Column(
        //     //   children: historyBarang.fotoPengirimanBarang.map((imagePath) {
        //     //     return Image.network(imagePath); // Assuming images are hosted online
        //     //   }).toList(),
        //     // ),
        //   ],
        // ),
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
                initialValue: profile.nama,
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
              historyBarang.fotoPengirimanBarang.isEmpty || historyBarang.fotoPengirimanBarang == []
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
                      items: historyBarang.fotoPengirimanBarang.map((item) {
                        String filename = basename(item); // Extract the filename from the path
                        return Container(
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
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
                                          colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Text(
                                        'No. ${historyBarang.fotoPengirimanBarang.indexOf(item) + 1} image - $filename', // Display filename
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
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
                              readOnly: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // controller: historyBarang.latitudeA,
                              initialValue: historyBarang.latitudeA.toString(),
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
                              // validator: latitudeValidator,
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // controller: longitudeAController,

                              initialValue: historyBarang.longitudeA.toString(),
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
                              readOnly: true,
                              // validator: longitudeValidator,
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
                                Latitude: historyBarang.latitudeA.toString(),
                                Longtitude: historyBarang.longitudeA.toString(),
                                LongtitudeTemp: historyBarang.longitudeB.toString(),
                                LatitudeTemp: historyBarang.latitudeB.toString(),
                                profile: profile,
                                fotoPengiriman: historyBarang.fotoPengirimanBarang,
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
                              readOnly: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // controller: latitudeBController,
                              initialValue: historyBarang.latitudeB.toString(),
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
                              // validator: latitudeValidator,
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              readOnly: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // controller: longitudeBController,
                              initialValue: historyBarang.longitudeB.toString(),
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
                              // validator: longitudeValidator,
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
                                Latitude: historyBarang.latitudeB.toString(),
                                Longtitude: historyBarang.longitudeB.toString(),
                                profile: profile,
                                LatitudeTemp: historyBarang.latitudeA.toString(),
                                LongtitudeTemp: historyBarang.longitudeB.toString(),
                                fotoPengiriman: historyBarang.fotoPengirimanBarang,
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
                // controller: selisihLokasiController,
                initialValue: historyBarang.selisihlokasi.toString(),
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
            ],
          ),
        ),
      ),
    );
  }
}
