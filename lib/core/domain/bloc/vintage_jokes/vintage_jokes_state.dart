part of 'vintage_jokes_bloc.dart';

@freezed
class VintageJokesState with _$VintageJokesState {
  factory VintageJokesState({
    required AuthStatus authStatus,
    required ThemeMode themeMode,
    required bool isLoading,
    Failure? failure,
    User? user,
  }) = _VintageJokesState;

  factory VintageJokesState.initial() => _VintageJokesState(
        authStatus: AuthStatus.unknown,
        themeMode: ThemeMode.system,
        isLoading: false,
      );
}
