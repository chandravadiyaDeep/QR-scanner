import 'package:flutter_test/flutter_test.dart';
import 'package:qr_digital_menu_owner/main.dart';

void main() {
  testWidgets('shows setup guidance when public environment config is missing', (tester) async {
    // This keeps the CI smoke test independent of private Supabase credentials.
    await tester.pumpWidget(const QrDigitalMenuApp());

    expect(find.text('QR Digital Menu'), findsOneWidget);
    expect(find.textContaining('configuration must be added'), findsOneWidget);
  });
}
