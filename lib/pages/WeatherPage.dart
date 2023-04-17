import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    // ignore: no_leading_underscores_for_local_identifiers
    LocationViewModel _locationViewModel =
        Provider.of<LocationViewModel>(context, listen: true);
    var format = DateFormat.yMd('tr');
    var dateString = format.format(DateTime.now());

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        body: _locationViewModel.state == ViewState.geldi
            ? SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      arama(_locationViewModel),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: SafeArea(
                            top: true,
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                            visible:
                                                _locationViewModel.location,
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                            )),
                                        Text(
                                          _locationViewModel.weather.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      _locationViewModel
                                          .weather.weather[0].description,
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
                                    Text(
                                      dateString,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 250,
                                      width: 250,
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/weather.png",
                                        image:
                                            "https://openweathermap.org/img/wn/${_locationViewModel.weather.weather[0].icon}@2x.png",
                                        fit: BoxFit.cover,
                                        placeholderFit: BoxFit.cover,
                                      ),
                                    ),
                                    Center(
                                      child: Wrap(
                                        spacing: 20,
                                        runSpacing: 20,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.center,
                                        children: [
                                          bilgiler(
                                            _locationViewModel,
                                            "Sıcaklık",
                                            "${_locationViewModel.weather.main.temp} °C",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Max',
                                            "${_locationViewModel.weather.main.tempMax} °C",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Min',
                                            "${_locationViewModel.weather.main.tempMin} °C",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Hissedilen',
                                            "${_locationViewModel.weather.main.feelsLike} °C",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Rüzgar',
                                            "${_locationViewModel.weather.wind.speed} km/h",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Nem',
                                            "%${_locationViewModel.weather.main.humidity.toString()}",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Basınç',
                                            "${_locationViewModel.weather.main.pressure} hPa",
                                          ),
                                          bilgiler(
                                            _locationViewModel,
                                            'Görüş',
                                            "${_locationViewModel.weather.visibility / 1000} km",
                                          ),
                                        ],
                                      ),
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
                      ),
                    ],
                  ),
                ),
              )
            : _locationViewModel.state == ViewState.geliyor
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Şehir Bulunamadı!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        arama(_locationViewModel),
                      ],
                    ),
                  ));
  }

  // ignore: no_leading_underscores_for_local_identifiers
  SizedBox bilgiler(
      LocationViewModel _locationViewModel, String bilgi, String deger) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            bilgi,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // '${((snapshot.data!.main['temp'] - 32 * 5) / 9).toStringAsFixed(2)}',
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Padding arama(LocationViewModel _locationViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _textEditingController,
                  onEditingComplete: () {
                    _locationViewModel.getWeather(_textEditingController.text);
                    _textEditingController.clear();
                  },
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    border: const OutlineInputBorder(),
                    hintText: "Şehir Adı Giriniz",
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (_textEditingController.text.isNotEmpty) {
                            _locationViewModel
                                .getWeather(_textEditingController.text);
                            _textEditingController.clear();
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios)),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (!_locationViewModel.isListening) {
                      var available = await speechToText.initialize();
                      if (available) {
                        setState(() {
                          _locationViewModel.isListening = true;
                          speechToText.listen(
                            onResult: (result) {
                              text = result.recognizedWords;

                              speechToText.isNotListening == true
                                  ? /*setState(() {
                                                      _locationViewModel
                                                          .getWeather(text);
                                                      _textEditingController
                                                          .clear();
                                                    })*/
                                  onay(text, _locationViewModel)
                                  : null;
                            },
                          );
                        });
                      }
                    }
                    await Future.delayed(const Duration(seconds: 5));
                    setState(() {});
                    _locationViewModel.isListening = false;
                  },
                  icon: AvatarGlow(
                    endRadius: 75,
                    animate: _locationViewModel.isListening,
                    duration: const Duration(milliseconds: 2000),
                    glowColor: Colors.blueAccent,
                    repeat: true,
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    showTwoGlows: true,
                    child: Icon(
                      Icons.mic,
                      color: _locationViewModel.isListening
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  )),
              IconButton(
                  onPressed: () async {
                    _locationViewModel.getCurrentLocation();
                  },
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  onay(String text, LocationViewModel _locationViewModel) async {
    TextToSpeech tts = TextToSpeech();
    String sehir = "";
    String texts =
        "$text Şehri İçin Hava Durumunu sorgulayacağım onaylıyor musun";
    await tts.speak(texts);
    await Future.delayed(const Duration(seconds: 3));
    SpeechToText speechToText2 = SpeechToText();
    var available = await speechToText2.initialize();
    if (available) {
      setState(() {
        _locationViewModel.isListening = true;
        speechToText2.listen(
          onResult: (result) {
            sehir = result.recognizedWords;
            speechToText2.isNotListening == true
                ? sehir.contains("Evet") == true ||
                        sehir.contains("Onay") == true ||
                        sehir.contains("Onaylıyorum") == true
                    ? setState(() {
                        _locationViewModel.getWeather(text);
                        _textEditingController.clear();
                      })
                    : null
                : null;
          },
        );
      });
    }
    await Future.delayed(const Duration(seconds: 5));
    setState(() {});
    _locationViewModel.isListening = false;
  }
}
