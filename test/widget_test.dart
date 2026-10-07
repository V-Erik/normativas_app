import 'package:flutter_test/flutter_test.dart';

import 'package:normativas_app/main.dart';

void main() {
  testWidgets('La app arranca en la pantalla de inicio de sesión', (tester) async {
    await tester.pumpWidget(const NormativasApp());

    expect(find.text('¡Bienvenido de nuevo!'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('El formulario de inicio de sesión valida los campos vacíos', (tester) async {
    await tester.pumpWidget(const NormativasApp());

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();

    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(find.text('Mínimo 4 caracteres'), findsOneWidget);
  });
}
