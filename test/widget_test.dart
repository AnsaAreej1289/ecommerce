import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/main.dart'; // Matches project name

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts correctly.
    expect(find.text('E-commerce UI'), findsNothing); // Adjust based on your app's initial UI
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}