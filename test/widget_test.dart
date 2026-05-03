import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:anime_st/app.dart';

void main() {
  testWidgets('App should render without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AnimeSTApp(),
      ),
    );

    // 验证应用标题存在
    expect(find.text('AnimeST'), findsOneWidget);
  });
}
