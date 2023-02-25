import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/app/constants/route.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';
import 'package:vintage_jokes/core/domain/model/failures.dart';
import 'package:vintage_jokes/core/presentation/screens/vintage_jokes_screen.dart';
import 'package:vintage_jokes/features/home/presentation/screens/home_screen.dart';
import 'package:vintage_jokes/features/profile/presentation/screens/profile_screen.dart';

import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_go_router_provider.dart';
import '../../../utils/mock_material_app.dart';
import '../../../utils/test_utils.dart';
import 'vintage_jokes_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<VintageJokesBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockVintageJokesBloc vintageJokesBloc;
  late MockVintageJokesBloc vintageJokesBlocError;
  late MockVintageJokesBloc vintageJokesBlocLoading;
  late MockGoRouter routerHome;
  late MockGoRouter routerProfile;

  setUp(() {
    vintageJokesBloc = MockVintageJokesBloc();
    vintageJokesBlocError = MockVintageJokesBloc();
    vintageJokesBlocLoading = MockVintageJokesBloc();
    routerHome = MockGoRouter();
    routerProfile = MockGoRouter();
    final VintageJokesState state = VintageJokesState.initial().copyWith(
      authStatus: AuthStatus.authenticated,
      user: mockUser,
      isLoading: false,
    );

    when(vintageJokesBloc.stream).thenAnswer(
      (_) => Stream<VintageJokesState>.fromIterable(<VintageJokesState>[state]),
    );
    when(vintageJokesBloc.state).thenAnswer((_) => state);
    when(vintageJokesBlocError.stream).thenAnswer(
      (_) => Stream<VintageJokesState>.fromIterable(<VintageJokesState>[
        state.copyWith(
          failure: const Failure.unexpected('Unexpected Error'),
        ),
      ]),
    );
    when(vintageJokesBlocError.state).thenAnswer(
      (_) =>
          state.copyWith(failure: const Failure.unexpected('Unexpected Error')),
    );
    when(vintageJokesBlocLoading.stream).thenAnswer(
      (_) => Stream<VintageJokesState>.fromIterable(<VintageJokesState>[
        state.copyWith(isLoading: true, user: null, failure: null),
      ]),
    );
    when(vintageJokesBlocLoading.state).thenAnswer(
      (_) => state.copyWith(isLoading: true, user: null, failure: null),
    );
    when(routerHome.location).thenAnswer((_) => RouteName.home.path);
    when(routerProfile.location).thenAnswer((_) => RouteName.profile.path);
    when(routerProfile.canPop()).thenAnswer((_) => false);
    when(routerHome.canPop()).thenAnswer((_) => false);
  });

  Widget buildVintageJokesScreen(
    Widget child,
    GoRouter router,
    VintageJokesBloc vintageJokesBloc,
  ) =>
      MockMaterialApp(
        child: MockGoRouterProvider(
          router: router,
          child: BlocProvider<VintageJokesBloc>(
            create: (BuildContext context) => vintageJokesBloc,
            child: Scaffold(
              body: VintageJokesScreen(
                child: child,
              ),
            ),
          ),
        ),
      );

  group('VintageJokes Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'vintage_jokes_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pumpAndSettle(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'home',
            builder: () => buildVintageJokesScreen(
              const HomeScreen(),
              routerHome,
              vintageJokesBloc,
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'profile',
            builder: () => buildVintageJokesScreen(
              const ProfileScreen(),
              routerProfile,
              vintageJokesBloc,
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'error',
            builder: () => buildVintageJokesScreen(
              const HomeScreen(),
              routerHome,
              vintageJokesBlocError,
            ),
          ),
        ],
      ),
    );
    goldenTest(
      'renders correctly',
      fileName: 'vintage_jokes_screen_loading'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'loading',
            builder: () => buildVintageJokesScreen(
              const HomeScreen(),
              routerHome,
              vintageJokesBlocLoading,
            ),
          ),
        ],
      ),
    );
  });
}
