import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/view/EditProfile.dart';
import 'package:tesflutter/view/HistoryKirimBarang.dart';
import 'package:tesflutter/view/login.dart';

import 'FormPengirimanBarang.dart';

class PengirimanBarang extends StatefulWidget {
  final Profile profile;
  const PengirimanBarang({super.key, required this.profile});

  @override
  State<PengirimanBarang> createState() => _PengirimanBarangState();
}

class _PengirimanBarangState extends State<PengirimanBarang> {
  late Profile profile;
  @override
  void initState() {
    profile = widget.profile;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> imageSliders = imgList_Send
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
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
                            // 'No. ${imgList.indexOf(item)} image',
                            'No. ${imgList_Send.indexOf(item)} image',
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
      .toList();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSend,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.add_box),
              SubJudul(
                text: "GoSend",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        backgroundColor: putih,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubJudul(text: "Kabar dari Gosend"),
              SizedBox(
                height: 10,
              ),
              CustomText(text: "Promo Spesial cuma buat kamu"),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 2,
                  autoPlay: true,
                ),
                items: imageSliders,
              )),
              SizedBox(
                height: 10,
              ),
              SubJudul(
                text: "Mau Kirim Paket?",
                fontSize: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        transision_page(
                            context,
                            InputData(
                              profile: profile,
                              type: "new",
                            ));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: SubJudul(
                                      text: "Dalam kota",
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Icon(
                                        Icons.navigate_next,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: CustomText(
                                  text: "Ke lokasi di kota yang sama.",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: SubJudul(
                                      text: "Dummy",
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Icon(
                                        Icons.navigate_next,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: CustomText(
                                  text: "Sub Dummy",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SubJudul(
                text: "Mau melihat History Pengiriman?",
                fontSize: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        transision_page(
                            context,
                            HistoryListPage(
                              profile: profile,
                            ));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: SubJudul(
                                      text: "Dalam kota",
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Icon(
                                        Icons.navigate_next,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: CustomText(
                                  text: "Ke lokasi di kota yang sama.",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: SubJudul(
                                      text: "Dummy",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Icon(
                                      Icons.navigate_next,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: CustomText(
                                  text: "Sub Dummy",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
