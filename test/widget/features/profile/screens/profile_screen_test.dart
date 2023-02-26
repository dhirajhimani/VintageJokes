import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';
import 'package:vintage_jokes/features/profile/presentation/screens/profile_screen.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';
import 'profile_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<VintageJokesBloc>()])
void main() {
  late MockVintageJokesBloc vintageJokesBloc;

  setUp(() {
    vintageJokesBloc = MockVintageJokesBloc();

    when(vintageJokesBloc.stream).thenAnswer(
      (_) => Stream<VintageJokesState>.fromIterable(<VintageJokesState>[
        VintageJokesState.initial().copyWith(
          authStatus: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ]),
    );
    when(vintageJokesBloc.state).thenAnswer(
      (_) => VintageJokesState.initial().copyWith(
        authStatus: AuthStatus.authenticated,
        user: mockUser,
        isLoading: false,
      ),
    );
  });
  Widget buildProfileScreen() => BlocProvider<VintageJokesBloc>(
        create: (BuildContext context) => vintageJokesBloc,
        child: const MockMaterialApp(
          child: Scaffold(
            body: ProfileScreen(),
          ),
        ),
      );

  group('Profile Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'profile_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: buildProfileScreen,
          ),
        ],
      ),
    );
  });
}
