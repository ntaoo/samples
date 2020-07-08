// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_stream_shopper/common/theme.dart';
import 'package:provider_stream_shopper/models/cart.dart';
import 'package:provider_stream_shopper/models/catalog.dart';
import 'package:provider_stream_shopper/screens/cart.dart';
import 'package:provider_stream_shopper/screens/catalog.dart';
import 'package:provider_stream_shopper/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel depends on CatalogModel, so a ProxyProvider is needed.
        ProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) => cart..updateCatalog(catalog),
          dispose: (context, self) => self.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => MyLogin(),
          '/catalog': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}
