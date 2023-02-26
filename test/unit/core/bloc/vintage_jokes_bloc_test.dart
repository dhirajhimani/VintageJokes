import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';
import 'package:vintage_jokes/core/domain/interface/i_user_repository.dart';
import 'package:vintage_jokes/core/domain/model/failures.dart';
import 'package:vintage_jokes/features/auth/domain/interface/i_auth_repository.dart';

import '../../../utils/test_utils.dart';
import 'vintage_jokes_bloc_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<IUserRepository>(),
  MockSpec<VintageJokesBloc>(),
  MockSpec<IAuthRepository>(),
])
void main() {
  late MockIUserRepository userRepository;
  late MockIAuthRepository authRepository;
  late VintageJokesBloc vintageJokesBloc;

  setUp(() {
    userRepository = MockIUserRepository();
    authRepository = MockIAuthRepository();
    vintageJokesBloc = VintageJokesBloc(userRepository, authRepository);
  });

  group('VintageJokesBloc initialize', () {
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        VintageJokesState.initial().copyWith(isLoading: true),
        vintageJokesBloc.state
            .copyWith(authStatus: AuthStatus.unauthenticated, user: null),
      ],
    );

    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => some(mockUser));

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        VintageJokesState.initial().copyWith(isLoading: true),
        vintageJokesBloc.state
            .copyWith(authStatus: AuthStatus.authenticated, user: mockUser),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.initialize(),
      expect: () => <dynamic>[
        VintageJokesState.initial().copyWith(isLoading: true),
        vintageJokesBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('VintageJokesBloc getUser ', () {
    setUp(() async {
      vintageJokesBloc = VintageJokesBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await vintageJokesBloc.initialize();
    });
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.getUser(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );

    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an authenticated with user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => some(mockUser));

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.getUser(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit  a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.getUser(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });

  group('VintageJokesBloc logout ', () {
    setUp(() async {
      vintageJokesBloc = VintageJokesBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await vintageJokesBloc.initialize();
    });
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(authRepository.logout()).thenAnswer((_) async => right(unit));

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.logout(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit a failed state',
      build: () {
        when(authRepository.logout()).thenAnswer(
          (_) async => left(Failure.unexpected(throwsException.toString())),
        );

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.logout(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          isLoading: false,
          failure: Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit a failed state when unexpected error occurs',
      build: () {
        when(authRepository.logout()).thenThrow(throwsException);

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.logout(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          isLoading: false,
          failure: Failure.unexpected(throwsException.toString()),
        ),
      ],
    );
  });

  group('VintageJokesBloc authenticate', () {
    setUp(() async {
      vintageJokesBloc = VintageJokesBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await vintageJokesBloc.initialize();
    });
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an authenticated user state',
      build: () => vintageJokesBloc,
      act: (VintageJokesBloc bloc) => bloc.authenticate(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit an unauthenticated with null user state',
      build: () {
        when(userRepository.user).thenAnswer((_) async => none());
        when(authRepository.logout()).thenAnswer((_) async => right(unit));

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.authenticate(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
        ),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit a failed state',
      build: () {
        when(userRepository.user).thenThrow(throwsException);

        return vintageJokesBloc;
      },
      act: (VintageJokesBloc bloc) => bloc.authenticate(),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(
          authStatus: AuthStatus.authenticated,
          isLoading: true,
          failure: null,
          user: mockUser,
        ),
        vintageJokesBloc.state
            .copyWith(failure: Failure.unexpected(throwsException.toString())),
      ],
    );
  });
  group('VintageJokesBloc switchTheme ', () {
    setUp(() async {
      vintageJokesBloc = VintageJokesBloc(userRepository, authRepository);
      when(userRepository.user).thenAnswer((_) async => some(mockUser));
      await vintageJokesBloc.initialize();
    });
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit a dark theme mode',
      build: () => vintageJokesBloc,
      act: (VintageJokesBloc bloc) async => bloc.switchTheme(Brightness.light),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(themeMode: ThemeMode.dark),
      ],
    );
    blocTest<VintageJokesBloc, VintageJokesState>(
      'should emit a light theme mode',
      build: () => vintageJokesBloc,
      act: (VintageJokesBloc bloc) async => bloc.switchTheme(Brightness.dark),
      expect: () => <dynamic>[
        vintageJokesBloc.state.copyWith(themeMode: ThemeMode.light),
      ],
    );
  });
}
