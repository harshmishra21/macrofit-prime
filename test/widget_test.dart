import 'package:flutter_test/flutter_test.dart';
import 'package:macrofit_prime/main.dart';
import 'package:provider/provider.dart';
import 'package:macrofit_prime/services/app_state.dart';

void main() {
  testWidgets('MacroFit Prime smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MacroFitApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(MacroFitApp), findsOneWidget);
  });
}
