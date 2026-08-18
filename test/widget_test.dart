import 'package:flutter_test/flutter_test.dart';
import 'package:swadhyay_fresh/main.dart';

void main() {
  testWidgets('Swadhyay app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SwadhyayApp());

    expect(find.text('Swadhyay'), findsOneWidget);
  });
}
