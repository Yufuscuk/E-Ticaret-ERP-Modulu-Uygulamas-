import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/product_list_view.dart';
import 'views/login_view.dart';
import 'views/admin_layout.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider);

    Widget homeWidget;
    if (authUser == null) {
      homeWidget = const LoginView();
    } else if (authUser.role == 'admin') {
      homeWidget = const AdminLayout();
    } else {
      homeWidget = const ProductListView();
    }

    return MaterialApp(
      title: 'Netsim E-Ticaret',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: homeWidget,
    );
  }
}
