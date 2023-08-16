import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/view/KirimBarang.dart';
import 'package:tesflutter/view/ProfileSetting.dart';
import 'package:tesflutter/view/searchBarDummy.dart';

import 'package:carousel_slider/carousel_slider.dart';

final List categories = [
  {
    'data': 'GoRide',
    'icon': Icon(
      Icons.motorcycle,
      size: 50,
    ),
  },
  {
    'data': 'GoCar',
    'icon': Icon(
      Icons.car_rental,
      size: 50,
    ),
  },
  {
    'data': 'GoFood',
    'icon': Icon(
      Icons.food_bank_rounded,
      size: 50,
    ),
  },
  {
    'data': 'GoSend',
    'icon': Icon(
      Icons.fastfood,
      size: 50,
    ),
  },
  {
    'data': 'GoMart',
    'icon': Icon(
      Icons.shopify,
      size: 50,
    ),
  },
  {
    'data': 'GoTagihan',
    'icon': Icon(
      Icons.receipt_long,
      size: 50,
    ),
  },
  {
    'data': 'GoTansit',
    'icon': Icon(
      Icons.train,
      size: 50,
    ),
  },
  {
    'data': 'Lainnya',
    'icon': Icon(
      Icons.dashboard_customize_sharp,
      size: 50,
    ),
  },
];
final List kotak = [
  {
    'Judul': 'gopay coins',
    'iconJudul': Icon(
      Icons.circle_rounded,
      size: 12,
      color: Colors.blue,
    ),
    'SubJudul1': '26',
    'SubJudul2': 'Klik buat detailnya',
  },
  {
    'Judul': 'gopay later',
    'iconJudul': Icon(
      Icons.watch_later,
      size: 12,
      color: Colors.blue,
    ),
    'SubJudul1': 'Aktifin sekarang!',
    'SubJudul2': 'klik disini',
  },
  {
    'Judul': 'gopay',
    'iconJudul': Icon(
      Icons.wallet,
      size: 12,
      color: Colors.blue,
    ),
    'SubJudul1': 'Rp.202.296',
    'SubJudul2': 'klik & cek riwayat',
  },
];

class MyHomePage extends StatefulWidget {
  final Profile profile;
  const MyHomePage({Key? key, required this.profile}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const colorIcon = Colors.black;

class _MyHomePageState extends State<MyHomePage> {
  late Profile profile;
  final int _currentIndex = 0;
  Future<bool> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission is granted
      return true;
    } else {
      // Permission is not granted
      return false;
    }
  }

  Future<bool> _checkPermissions() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    status = await Permission.storage.request();
    return status.isGranted;
  }

  @override
  void initState() {
    profile = widget.profile;
    super.initState();
    init_State();
  }

  void init_State() async {
    Geolocator.requestPermission();

    await _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true; // Return true to confirm the pop
      },
      child: Scaffold(
        bottomNavigationBar: NavBar(currentIndex: _currentIndex, profile: profile),

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(76), // Adjust the height as needed
          child: GojekSearchBar(
            profile: profile,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                      child: Container(
                        // padding: EdgeInsets.all(10),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  height: 90,
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: true,
                                ),
                                items: imageSliders_1,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.upload_rounded,
                                      color: Colors.blue.shade900,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  SubJudul(
                                    text: "Bayar",
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(1),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blue.shade900,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  SubJudul(
                                    text: "Top Up",
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(1),
                                    child: Icon(
                                      Icons.rocket_launch,
                                      color: Colors.blue.shade900,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  SubJudul(
                                    text: "Eksplor",
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10), // Add space here
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: categories.map((category) {
                          return GestureDetector(
                            onTap: () {
                              // Handle category button tapped
                            },
                            child: Container(
                              // constraints: const BoxConstraints(

                              //   maxHeight: 80, // Set fixed height
                              // ),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                // color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(0.0),
                              child: category['data'] != "GoSend"
                                  ? GestureDetector(
                                      onTap: () {
                                        final snackBar = SnackBar(
                                          content: Text("Hanya bisa menggunakan fungsi Go Send"),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        // Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                constraints: const BoxConstraints(
                                                  maxHeight: 80, // Set fixed height
                                                ),
                                                decoration: BoxDecoration(
                                                    // color: Colors.grey.shade300,
                                                    // borderRadius: BorderRadius.circular(15),
                                                    ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: category['icon'],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 0,
                                                child: CustomText(
                                                  text: category['data'],
                                                  fontSize: 12,
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        transision_page(context, PengirimanBarang(profile: profile));
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                maxHeight: 80, // Set fixed height
                                              ),
                                              decoration: BoxDecoration(
                                                  // color: Colors.grey.shade300,
                                                  // borderRadius: BorderRadius.circular(15),
                                                  ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  // borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.travel_explore,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: CustomText(
                                              text: "GoSend",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                 
              ],
            ),
          ),
        ),
        // body: MapScreen(),

        // body: const GeolocatorWidget(),
        // body: Map_Screen_RealTime(),
        // body: Container(),
      ),
    );
  }
} 
class GojekSearchBar extends StatelessWidget {
  final Profile profile;
  const GojekSearchBar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: colorDefaultAplikasi,
          height: 10, // Space at the top
        ),
        AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        color: Colors.grey.shade800,
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          print('Search button pressed');
                          showSearch(context: context, delegate: SearchBarDelegate());
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showSearch(context: context, delegate: SearchBarDelegate());
                          },
                          child: CustomText(
                            text: "Cari layanan, makanan, & tujuan",
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      print("person selected");
                      transision_page(
                          context,
                          ProfileSetting(
                            profile: profile,
                          ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProfileSetting()));
                    },
                  ),
                ),
              ),
            ],
          ),
          elevation: 0, // No shadow
        ),
        Container(
          color: colorDefaultAplikasi,
          height: 10,
        ),
      ],
    );
  }
}

class CollapsibleCardList extends StatefulWidget {
  @override
  _CollapsibleCardListState createState() => _CollapsibleCardListState();
}

class _CollapsibleCardListState extends State<CollapsibleCardList> {
  List<bool> _cardExpandedState = List.generate(3, (index) => false);

  void _toggleCardExpansion(int cardIndex) {
    setState(() {
      _cardExpandedState[cardIndex] = !_cardExpandedState[cardIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return CollapsibleCard(
          index: index,
          isExpanded: _cardExpandedState[index],
          onToggle: _toggleCardExpansion,
        );
      },
    );
  }
}

class CollapsibleCard extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final Function(int) onToggle;

  CollapsibleCard({required this.index, required this.isExpanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('Card $index'),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                onToggle(index);
              },
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Card $index content goes here...'),
            ),
        ],
      ),
    );
  }
}
