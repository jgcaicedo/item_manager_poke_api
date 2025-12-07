import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:item_manager_poke_api/view/api_list_page.dart';
import 'package:item_manager_poke_api/view/item_detail_page.dart';
import 'package:item_manager_poke_api/utils/constants/app_theme.dart';
import 'package:item_manager_poke_api/data/models/item.dart';

import 'package:item_manager_poke_api/view/pages/item_form_page.dart';
import 'package:item_manager_poke_api/view/pages/item_list_page.dart';

/// Clase principal de la aplicación Item Manager Poke API.
/// Configura el tema, las rutas y el punto de entrada de la app.
class ItemManagerPokeApiApp extends StatelessWidget {
  const ItemManagerPokeApiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Item Manager Poke API',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

//Rutas de la aplicación
final GoRouter router = GoRouter(
  initialLocation: '/prefs',
  routes: [
    GoRoute(
      path: '/prefs',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ItemListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path:'/prefs/new',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: ItemFormPage(itemToEdit: state.extra as Item?),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/prefs/:id',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: ItemDetailPage(itemId: state.pathParameters['id']!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/api-list',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ApiListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    )
  ]

);