import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/fruit_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test1', (WidgetTester tester) async {
    final fontData = File('assets/fonts/Roboto-Regular.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
    final fontLoader = FontLoader('Roboto')..addFont(fontData);
    await fontLoader.load();

    await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
            create: (BuildContext context) => FruitBloc(),
            child: Text('asd'))));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('test1.png'));
  });
}
