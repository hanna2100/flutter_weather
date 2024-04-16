import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_provider/constants/constants.dart';
import 'package:open_weather_provider/pages/search_page.dart';
import 'package:open_weather_provider/pages/settings_page.dart';
import 'package:open_weather_provider/providers/providers.dart';
import 'package:open_weather_provider/providers/weather/weather_provider.dart';
import 'package:open_weather_provider/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider _weatherProv;

  @override
  void initState() {
    super.initState();
    _weatherProv = context.read<WeatherProvider>();
    _weatherProv.addListener(_registerListener);
  }

  @override
  void dispose() {
    super.dispose();
    _weatherProv.removeListener(_registerListener);
  }

  void _registerListener() {
    final WeatherState ws = context.read<WeatherProvider>().state;

    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg ?? 'Error!');
    }
  }

  @override
  Widget build(BuildContext context) {

    String showTemperature(double temperature) {
      final tempUnit = context.watch<TempSettingsProvider>().state.tempUnit;

      if(tempUnit == TempUnit.fahrenheit) {
        return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
      }
      return temperature.toStringAsFixed(2) + '℃';
    }

    Widget showIcon(String icon) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/loading.gif',
        image: 'http://$kIconHost/img/wn/$icon@4x.png',
        width: 96,
        height: 96,
      );
    }

    Widget formatText(String description) {
      final formattedString = description.titleCase;
      return Text(
        formattedString,
        style: const TextStyle(fontSize: 24.0),
        textAlign: TextAlign.center,
      );
    }

    Widget _showWeather() {
      final state = context.watch<WeatherProvider>().state;

      if (state.status == WeatherStatus.initial) {
        return Center(
          child: Text(
            '도시를 선택해주세요.',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }

      if (state.status == WeatherStatus.loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.status == WeatherStatus.error && state.weather.name.isEmpty) {
        return Center(
          child: Text(
            '도시를 선택해주세요.',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }

      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          Text(
            state.weather.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TimeOfDay.fromDateTime(state.weather.lastUpdated)
                    .format(context),
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                '${state.weather.country}',
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          const SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showTemperature(state.weather.temp),
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                children: [
                  Text(
                    showTemperature(state.weather.tempMax),
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    showTemperature(state.weather.tempMin),
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Spacer(),
              showIcon(state.weather.icon),
              Expanded(
                flex: 3,
                child: formatText(state.weather.description),
              ),
              const Spacer(),
            ],
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));

                if (_city != null) {
                  context.read<WeatherProvider>().fetchWeather(_city!);
                }
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: _showWeather(),
    );
  }
}
