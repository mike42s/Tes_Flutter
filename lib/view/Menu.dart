import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/view/KirimBarang.dart';
import 'package:tesflutter/view/ProfileSetting.dart';
import 'package:tesflutter/view/searchBarDummy.dart';

import 'package:carousel_slider/carousel_slider.dart';

final List categories = [
  {
    'data': 'Films',
    'icon': Icon(Icons.movie),
  },
  {
    'data': 'Books',
    'icon': Icon(Icons.book),
  },
  {
    'data': 'Music',
    'icon': Icon(Icons.music_note),
  },
  {
    'data': 'Food',
    'icon': Icon(Icons.fastfood),
  },
  {
    'data': 'Travel',
    'icon': Icon(Icons.map),
  },
  {
    'data': 'Min',
    'icon': Icon(Icons.minimize),
  },
  {
    'data': 'Lengths Support..................',
    'icon': Icon(Icons.more),
  },
  {
    'data': 'Art',
    'icon': Icon(Icons.abc),
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

  @override
  void initState() {
    profile = widget.profile;
    super.initState();
    init_State();
  }

  void init_State() async {
    Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Intercept back button press
        // Close the entire app using SystemNavigator
        SystemNavigator.pop();
        return true; // Return true to confirm the pop
      },
      child: Scaffold(
        bottomNavigationBar:
            NavBar(currentIndex: _currentIndex, profile: profile),
        // appBar: AppBar(
        //   title: StyledSearchBar(),
        //   // leading: Container(
        //   //   padding: EdgeInsets.only(right: 10.0),
        //   //   child: IconButton(
        //   //     enableFeedback: false,
        //   //     color: colorIcon,
        //   //     splashColor: Colors.transparent,
        //   //     splashRadius: 1,
        //   //     icon: Icon(Icons.abc),
        //   //     onPressed: () {
        //   //       print("You Click This ABC");
        //   //     },
        //   //   ),
        //   // ),
        //   centerTitle: true,
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.search),
        //       onPressed: () {
        //         // Handle search icon pressed
        //         showSearch(context: context, delegate: SearchBarDelegate());
        //       },
        //     ),
        //   ],
        // ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100), // Adjust the height as needed
          child: GojekSearchBar(
            profile: profile,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.blue.shade200,
                      padding: EdgeInsets.all(20),
                      child: Container(
                        // color: Colors.white,
                        // child: CarouselSlider(
                        //   options: CarouselOptions(
                        //     enableInfiniteScroll: false,
                        //     height: 50,
                        //     aspectRatio: 2.0,
                        //     enlargeCenterPage: true,
                        //     scrollDirection: Axis.vertical,
                        //     autoPlay: true,
                        //   ),
                        //   items: imageSliders,
                        // ),
                        child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Icon(Icons.abc),
                                    Text("Gojek")
                                  ]),
                                ),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                              ],
                            )),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10), // Add space here
                      child: Wrap(
                        spacing: 15,
                        runSpacing: 20,
                        children: categories.map((category) {
                          return GestureDetector(
                            onTap: () {
                              // Handle category button tapped
                            },
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 80, // Set fixed height
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Icon(
                                    //   Icons.motorcycle,
                                    //   size: 40,
                                    // ),
                                    category['icon'],
                                    Text(category['data']),
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
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    transision_page(
                        context, PengirimanBarang(profile: profile));
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 80, // Set fixed height
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.motorcycle,
                            size: 40,
                          ),
                          CustomText(
                            text: "GoSend",
                          ),
                        ],
                      ),
                    ),
                  ),
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
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(120), // Adjust the height as needed
//         child: GojekSearchBar(),
//       ),
//       body: Center(
//         child: Text('Content goes here'),
//       ),
//     );
//   }
// }

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
                          showSearch(
                              context: context, delegate: SearchBarDelegate());
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: SearchBarDelegate());
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

  CollapsibleCard(
      {required this.index, required this.isExpanded, required this.onToggle});

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
