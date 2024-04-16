import 'package:flutter/material.dart';
import 'package:open_weather_provider/providers/providers.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text('온도 단위'),
          subtitle: Text('섭씨/화씨 (기본: 섭씨)'),
          trailing: Switch(
            value: context.watch<TempSettingsProvider>().state.tempUnit == TempUnit.celsius? true : false,
            onChanged: (bool value) {
              context.read<TempSettingsProvider>().toggleTempUnit();
            },
          ),
        ),
      ),
    );
  }
}
