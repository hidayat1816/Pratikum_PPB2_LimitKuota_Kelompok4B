import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:praktikum_ppb2_limitkuota_kelompok4b/main.dart';

void main() {
  testWidgets('App loads Network Page', (WidgetTester tester) async {

    await tester.pumpWidget(const MyApp());

    expect(find.text('Monitoring Data'), findsOneWidget);
    expect(find.byIcon(Icons.wifi), findsOneWidget);
    expect(find.byIcon(Icons.signal_cellular_alt), findsOneWidget);
  });
}