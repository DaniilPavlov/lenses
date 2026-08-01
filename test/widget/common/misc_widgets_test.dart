import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/assets_gen/assets.gen.dart';
import 'package:lenses/common/utils/constants/navigator_keys.dart';
import 'package:lenses/common/widgets/app_bar/app_bar_leading_back_arrow.dart';
import 'package:lenses/common/widgets/custom_svg_picture.dart';
import 'package:lenses/common/widgets/lines/dotted_line.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('DottedLine and CustomSvgPicture build', (tester) async {
    await tester.pumpApp(
      Column(
        children: [
          const DottedLine(lineLength: 40, dashLength: 2, dashGapLength: 2),
          CustomSvgPicture(Assets.icons.check.path, height: 16, width: 16),
          CustomSvgPicture.square(Assets.icons.error.path, dimension: 16),
        ],
      ),
    );
    expect(find.byType(DottedLine), findsOneWidget);
    expect(find.byType(CustomSvgPicture), findsNWidgets(2));
  });

  testWidgets('AppBarLeadingBackArrow pops', (tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(56),
                      child: ColoredBox(
                        color: Colors.white,
                        child: AppBarLeadingBackArrow(),
                      ),
                    ),
                    body: Text('detail'),
                  ),
                ),
              );
            },
            child: const Text('open'),
          );
        },
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('detail'), findsOneWidget);
    await tester.tap(find.byType(AppBarLeadingBackArrow));
    await tester.pumpAndSettle();
    expect(find.text('detail'), findsNothing);
  });

  testWidgets('RootNavigatorKey facade methods', (tester) async {
    final key = GlobalKey<NavigatorState>();
    final facade = RootNavigatorKey(key);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                facade.push(
                  MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('pushed'))),
                );
              },
              child: const Text('go'),
            );
          },
        ),
      ),
    );

    expect(facade.currentContext, isNotNull);
    expect(facade.currentState, isNotNull);
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.text('pushed'), findsOneWidget);
    facade.pop();
    await tester.pumpAndSettle();
    expect(find.text('pushed'), findsNothing);

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    facade.popUntil((route) => route.isFirst);
    await tester.pumpAndSettle();
    expect(find.text('go'), findsOneWidget);
  });
}
