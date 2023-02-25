import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_info_text_field.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('VintageJokesInfoTextField Widget Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'vintage_jokes_info_text_field'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default(expanded)',
            constraints: const BoxConstraints(minWidth: 200),
            child: const VintageJokesInfoTextField(
              title: 'Title',
              description: 'Description',
            ),
          ),
          GoldenTestScenario(
            name: 'shrink',
            child: const VintageJokesInfoTextField(
              title: 'Title',
              description: 'Description',
              isExpanded: false,
            ),
          ),
        ],
      ),
    );
  });
}
