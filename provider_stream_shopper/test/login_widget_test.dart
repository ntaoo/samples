import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider_stream_shopper/models/cart.dart';
import 'package:provider_stream_shopper/models/catalog.dart';
import 'package:provider_stream_shopper/screens/catalog.dart';
import 'package:provider_stream_shopper/screens/login.dart';

void main() {
  testWidgets('Login page Widget test', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider(create: (context) => CatalogModel()),
        ProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) => cart..updateCatalog(catalog),
          dispose: (context, self) => self.dispose(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => MyLogin(),
          '/catalog': (context) => MyCatalog(),
        },
      ),
    ));

    // Verifying the behaviour of ENTER button.
    await tester.tap(find.text('ENTER'));
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsOneWidget);
  });
}
