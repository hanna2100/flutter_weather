import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_weather_provider/providers/providers.dart';
import 'package:state_notifier/state_notifier.dart';

part 'temp_settings_state.dart';

class TempSettingsProvider extends StateNotifier<TempSettingsState>{
  TempSettingsProvider(): super(TempSettingsState.initial());

  void toggleTempUnit() {
    state = state.copyWith(
        tempUnit: state.tempUnit == TempUnit.celsius
            ? TempUnit.fahrenheit
            : TempUnit.celsius);
  }
}
