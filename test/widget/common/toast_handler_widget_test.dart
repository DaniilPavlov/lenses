import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/toast_handler/toast_handler_widget.dart';
import 'package:lenses/core/lenses/models/toast_model.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('ToastHandlerWidget.handle shows toast', (tester) async {
    await tester.pumpApp(
      ToastHandlerWidget(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                ToastHandlerWidget.handle(
                  context,
                  toast: ToastModel(isError: false, message: 'Saved'),
                );
                ToastHandlerWidget.handle(
                  context,
                  toast: ToastModel(isError: true, message: 'Boom'),
                );
              },
              child: const Text('show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Boom'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
