import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:weather_app/view_models/location_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  String text = "";
  bool isListening = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocationViewModel _locationViewModel =
        Provider.of<LocationViewModel>(context, listen: false);
    _locationViewModel.getCurrentLocation();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("WeatherApp"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                focusColor: const Color.fromARGB(255, 34, 126, 167),
                border: const UnderlineInputBorder(),
                hintText: "Şehir Adı Giriniz",
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/weatherPage");
                    },
                    icon: const Icon(Icons.mic))),
          ),
          Center(
            child: AvatarGlow(
              endRadius: 75,
              animate: isListening,
              duration: Duration(milliseconds: 2000),
              glowColor: Colors.blueAccent,
              repeat: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              showTwoGlows: true,
              child: GestureDetector(
                onTap: () async {
                  if (!isListening) {
                    var available = await speechToText.initialize();
                    if (available) {
                      setState(() {
                        isListening = true;
                        speechToText.listen(
                          onResult: (result) {
                            text = result.recognizedWords;

                            speechToText.isNotListening == true
                                ? setState(() {
                                    isListening = false;
                                    _textEditingController.text = text;
                                  })
                                : null;
                          },
                        );
                      });
                    }
                  }
                },
                child: const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.mic),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  konusma(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sesli Komut',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Lütfen Alttaki Tuşa Basıp Hava Durumuna Erişmek İstediğiniz Şehrin İsmini Söyleyiniz',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: AvatarGlow(
                endRadius: 75,
                animate: isListening,
                duration: Duration(milliseconds: 2000),
                glowColor: Colors.blueAccent,
                repeat: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                showTwoGlows: true,
                child: GestureDetector(
                  onTapDown: (details) async {
                    if (!isListening) {
                      var available = await speechToText.initialize();
                      if (available) {
                        setState(() {
                          isListening = true;
                          speechToText.listen(
                            onResult: (result) {
                              text = result.recognizedWords;
                            },
                          );
                        });
                      }
                    }
                  },
                  onTapUp: (details) {
                    setState(() {
                      isListening = false;
                    });
                    speechToText.stop();
                    print(text);
                  },
                  child: CircleAvatar(
                    radius: 35,
                    child: Icon(Icons.mic),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  dinleme() async {
    var available = await speechToText.initialize();
    if (available) {
      setState(() {
        speechToText.listen(
          onResult: (result) {
            text = result.recognizedWords;
          },
        );
      });
    }
  }
}
