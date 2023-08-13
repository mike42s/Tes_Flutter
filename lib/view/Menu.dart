import 'package:flutter/material.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/view/ProfileSetting.dart';
import 'package:tesflutter/view/searchBarDummy.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const colorIcon = Colors.black;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100), // Adjust the height as needed
        child: GojekSearchBar(),
      ),
      body: Container(),
      // body: MapScreen(),

      // body: const GeolocatorWidget(),
      // body: Map_Screen_RealTime(),
      // body: Container(),
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
  const GojekSearchBar({super.key});

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
                      transision_page(context, ProfileSetting());
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
