import 'package:flutter/material.dart';
import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';
import 'package:tesflutter/defaultSetting.dart';
import 'package:tesflutter/modal/Profile.dart';
import 'package:tesflutter/modal/dbprovider_database.dart';
import 'package:tesflutter/view/CreateProfile.dart';
import 'package:tesflutter/view/Menu.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..add(AniProps.translateY, Tween(begin: -30.0, end: 0.0),
          const Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, animation.get(AniProps.translateY)),
            child: child),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _controller_username;
  late final TextEditingController _controller_password;
  late Profile _user;
  bool userLogin = false;
  @override
  void initState() {
    _user = Profile(nama: '', noktp: '', fotodriver: '', password: '');
    ProfileManager.getProfile().then((value) {
      setState(() {
        // Check if the user is not null to set the userLogin flag to true
        if (value != null) {
          _user = value;
          // print('ID: ${_user.id}');
          // print('Username: ${_user.username}');
          // print('Nama: ${_user.nama}');
          // print('Level: ${_user.level}');
          // print('Status: ${_user.status}');
          userLogin = true;
        } else {
          userLogin = false;
        }
      });
    });
    _controller_username = TextEditingController();
    _controller_password = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller_username.dispose();
    _controller_password.dispose();
    super.dispose();
  }

  MaterialStateProperty<Color?> customColor_Grey =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.green.shade600; // Color for pressed state
      }
      if (states.contains(MaterialState.hovered)) {
        return Colors.green.shade700; // Color for hovered state
      }
      return Colors.green.shade800; // Default color
    },
  );
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    print("Bool Login: " + userLogin.toString());
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          if (userLogin == false) {
            return Scaffold(
              body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.green.shade300,
                  Colors.green.shade400,
                  colorDefaultAplikasi,
                  Colors.green.shade800,
                ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(
                              1,
                              const Text(
                                "Hey",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 40),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                              1.3,
                              const Text(
                                "Welcome Back",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 60,
                                ),
                                FadeAnimation(
                                    1.4,
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 20,
                                                offset: const Offset(0, 10))
                                          ]),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: TextField(
                                              controller: _controller_username,
                                              decoration: const InputDecoration(
                                                  hintText: "Username",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: TextField(
                                              controller: _controller_password,
                                              obscureText: _obscureText,
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none,
                                                labelText: 'Password',
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    _obscureText
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                  ),
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        _obscureText =
                                                            !_obscureText;
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1.6,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: customColor_Grey,
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            String message = "Error not Found";

                                            final Profile _user =
                                                await DBProvider.db.getUser(
                                              _controller_username.text,
                                              _controller_password.text,
                                            );

                                            print("user : " + _user.toString());
                                            if (_user.nama != "") {
                                              if (_controller_username.text ==
                                                      "DRIVER 1" &&
                                                  _controller_password.text ==
                                                      "1234") {
                                                message = "Berhasil Login";
                                                //need dummy side
                                                Profile _profile = Profile(
                                                  nama: "DRIVER 1",
                                                  password: "1234",
                                                  fotodriver: '',
                                                  noktp: '',
                                                );
                                                ProfileManager.saveProfile(
                                                    _profile);
                                                transision_replacement(
                                                  context,
                                                  MyHomePage(
                                                    profile: _profile,
                                                  ),
                                                );
                                              } else {
                                                message = "Berhasil Login";
                                                if (_controller_username.text ==
                                                        _user.nama &&
                                                    _controller_password.text ==
                                                        _user.password
                                                            .toString()) {
                                                  final x = ProfileManager
                                                      .saveProfile(_user);
                                                  transision_replacement(
                                                    context,
                                                    MyHomePage(
                                                      profile: _user,
                                                    ),
                                                  );
                                                } else {
                                                  message = "Gagal Login";
                                                }
                                              }
                                            }
                                            final snackBar = SnackBar(
                                              content: Text(message),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          child: const Text("Log In"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: customColor_Grey,
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            transision_page(
                                                context, BuatProfile());
                                          },
                                          child: const Text("Create Account"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            Future.delayed(Duration(milliseconds: 0), () {
              return transision_page(
                context,
                MyHomePage(profile: _user),
              );
            });

            return Container();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: Text('This page only supports portrait orientation.'),
            ),
          );
        }
      },
    );
  }
}

Route _createRoute(Widget x) {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => x,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1, 0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
