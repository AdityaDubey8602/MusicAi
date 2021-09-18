import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_ai_app/model/music.dart';
import 'package:music_ai_app/utils/ai_util.dart';
import 'package:velocity_x/velocity_x.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<MyMusic> music;

  late MyMusic _selectedMusic;
  Color? _selectedColor;
  bool _isPlaying = false;
  final sugg = [
    "Play",
    "Stop",
    "Play rock music",
    "Play 107 FM",
    "Play next",
    "Play 104 FM",
    "Pause",
    "Play previous",
    "Play pop music"
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchMusic();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setupAlan() {
    AlanVoice.addButton(
        "a098abea68fdf7c654e2572c6800eb502e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        _playMusic(_selectedMusic.url);
        break;

      case "play_channel":
        final id = response["id"];
        _audioPlayer.pause();
        MyMusic newMusic = music.firstWhere((element) => element.id == id);
        music.remove(newMusic);
        music.insert(0, newMusic);
        _playMusic(newMusic.url);
        break;
      case "stop":
        _audioPlayer.stop();
        break;

      case "next":
        final index = _selectedMusic.id;
        MyMusic newMusic;
        if (index + 1 > music.length) {
          newMusic = music.firstWhere((element) => element.id == 1);
          music.remove(newMusic);
          music.insert(0, newMusic);
        } else {
          newMusic = music.firstWhere((element) => element.id == index + 1);
          music.remove(newMusic);
          music.insert(0, newMusic);
        }
        _playMusic(newMusic.url);
        break;

      case "prev":
        final index = _selectedMusic.id;
        MyMusic newMusic;
        if (index - 1 <= 0) {
          newMusic = music.firstWhere((element) => element.id == 1);
          music.remove(newMusic);
          music.insert(0, newMusic);
        } else {
          newMusic = music.firstWhere((element) => element.id == index - 1);
          music.remove(newMusic);
          music.insert(0, newMusic);
        }
        _playMusic(newMusic.url);
        break;

      default:
        print("Command was ${response['command']}");
        break;
    }
  }

  fetchMusic() async {
    final musicJson = await rootBundle.loadString('assets/radio.json');
    music = MyMusicList.fromJson(musicJson).music;
    _selectedMusic = music[0];
    _selectedColor = Color(int.parse(_selectedMusic.color));
    print(music);
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedMusic = music.firstWhere((element) => element.url == url);
    print(_selectedMusic.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
            color: _selectedColor ?? AIColors.primaryColor2,
            child: music != null
                ? [
                    100.heightBox,
                    "All Channels".text.xl.white.semiBold.make().px16(),
                    20.heightBox,
                    ListView(
                      padding: Vx.m0,
                      shrinkWrap: true,
                      children: music
                          .map((e) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(e.icon),
                                ),
                                title: "${e.name} FM".text.white.make(),
                                subtitle: e.tagline.text.white.make(),
                              ))
                          .toList(),
                    ).expand(),
                  ].vStack(crossAlignment: CrossAxisAlignment.start)
                : const Offstage()),
      ),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                  colors: [
                    AIColors.primaryColor2,
                    _selectedColor ?? AIColors.primaryColor1,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
              .make(),
          [
            AppBar(
              title: 'AI Music'.text.xl4.bold.white.make().shimmer(
                    primaryColor: Vx.purple300,
                    secondaryColor: Colors.white,
                  ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
            ).h(100).p16(),
            "Start with - Hey Alan!".text.italic.semiBold.white.make(),
            10.heightBox,
            VxSwiper.builder(
              itemCount: sugg.length,
              height: 50.0,
              viewportFraction: 0.35,
              autoPlay: true,
              autoPlayAnimationDuration: 3.seconds,
              autoPlayCurve: Curves.linear,
              enableInfiniteScroll: true,
              itemBuilder: (context, index) {
                final s = sugg[index];
                return Chip(
                  label: s.text.make(),
                  backgroundColor: Vx.randomColor,
                );
              },
            ),
          ].vStack(),
          30.heightBox,
          music != null
              ? VxSwiper.builder(
                  itemCount: music.length,
                  aspectRatio: 1.0,
                  onPageChanged: (index) {
                    _selectedMusic = music[index];
                    final colorHex = music[index].color;
                    _selectedColor = Color(int.parse(colorHex));
                    setState(() {});
                  },
                  enlargeCenterPage: true,
                  itemBuilder: (context, index) {
                    final mus = music[index];
                    return VxBox(
                      child: ZStack([
                        Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: VxBox(
                                    child: mus.category.text.uppercase.white
                                        .make()
                                        .p16())
                                .height(40)
                                .black
                                .alignCenter
                                .withRounded(value: 10.0)
                                .make()),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              mus.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              mus.tagline.text.sm.white.semiBold.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: [
                              Icon(
                                CupertinoIcons.play_circle,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              "Double Tap To Play".text.gray300.make()
                            ].vStack()),
                      ]),
                    )
                        .clip(Clip.antiAlias)
                        .bgImage(
                          DecorationImage(
                              image: NetworkImage(mus.image),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              )),
                        )
                        .border(color: Colors.black, width: 5.0)
                        .withRounded(value: 60.0)
                        .make()
                        .onInkDoubleTap(() {
                      _playMusic(mus.url);
                    }).p16();
                  },
                ).centered()
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
          Align(
                  alignment: Alignment.bottomCenter,
                  child: [
                    if (_isPlaying)
                      "Playing Now - ${_selectedMusic.name}.MP3"
                          .text
                          .makeCentered(),
                    Icon(
                      _isPlaying
                          ? CupertinoIcons.stop_circle
                          : CupertinoIcons.play_circle,
                      color: Colors.white,
                      size: 50.0,
                    ).onInkTap(() {
                      if (_isPlaying) {
                        _audioPlayer.stop();
                      } else {
                        _playMusic(_selectedMusic.url);
                      }
                    }),
                  ].vStack())
              .pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
