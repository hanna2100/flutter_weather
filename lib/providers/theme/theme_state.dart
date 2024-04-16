part of 'theme_provider.dart';

enum AppTheme {
  light, dark,
}

class ThemeState extends Equatable{
  final AppTheme appTheme;

  ThemeState({this.appTheme = AppTheme.light});

  factory ThemeState.initial() => ThemeState();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [appTheme];

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }
}