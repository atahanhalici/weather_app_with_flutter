import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:weather_app/view_models/location_viewmodel.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  SpeechToText speechToText = SpeechToText();
  String text = "";
  bool isListening = false;
  TextEditingController _textEditingController = TextEditingController();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    LocationViewModel _locationViewModel =
        Provider.of<LocationViewModel>(context, listen: true);

    String text =
        "${_locationViewModel.weather.name} Şehrinde Hava Bugün ${_locationViewModel.weather.main.temp.toString()} Derece ve ${_locationViewModel.weather.weather[0].description}";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
            )
          ],
        ),
        backgroundColor: const Color(0xFF676BD0),
        body: _locationViewModel.state == ViewState.geldi
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 30.0,
                  ),
                  child: SafeArea(
                    top: true,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: _visible,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _textEditingController,
                                        decoration: InputDecoration(
                                          focusColor: const Color.fromARGB(
                                              255, 34, 126, 167),
                                          border: const UnderlineInputBorder(),
                                          hintText: "Şehir Adı Giriniz",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (_textEditingController
                                                    .text.isNotEmpty) {
                                                  _locationViewModel.getWeather(
                                                      _textEditingController
                                                          .text);
                                                  _textEditingController
                                                      .clear();
                                                  _visible = false;
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_forward_ios)),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          if (!isListening) {
                                            var available =
                                                await speechToText.initialize();
                                            if (available) {
                                              setState(() {
                                                isListening = true;
                                                speechToText.listen(
                                                  onResult: (result) {
                                                    text =
                                                        result.recognizedWords;

                                                    speechToText.isNotListening ==
                                                            true
                                                        ? setState(() {
                                                            isListening = false;
                                                            _locationViewModel
                                                                .getWeather(
                                                                    text);
                                                            _textEditingController
                                                                .clear();
                                                            _visible = false;
                                                          })
                                                        : null;
                                                  },
                                                );
                                              });
                                            }
                                          }
                                        },
                                        icon: AvatarGlow(
                                          endRadius: 75,
                                          animate: isListening,
                                          duration:
                                              Duration(milliseconds: 2000),
                                          glowColor: Colors.blueAccent,
                                          repeat: true,
                                          repeatPauseDuration:
                                              Duration(milliseconds: 100),
                                          showTwoGlows: true,
                                          child: Icon(
                                            Icons.mic,
                                            color: isListening
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              _locationViewModel.weather.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              _locationViewModel.weather.weather[0].description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              '6 Aralık, 2023',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        "https://openweathermap.org/img/wn/${_locationViewModel.weather.weather[0].icon}@2x.png",
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Sıcaklık',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      // '${((snapshot.data!.main['temp'] - 32 * 5) / 9).toStringAsFixed(2)}',
                                      _locationViewModel.weather.main.temp
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Rüzgar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${_locationViewModel.weather.wind.speed} km/h",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Nem',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "%${_locationViewModel.weather.main.humidity.toString()}",
                                      // '${snapshot.data!.main['humidity']}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
