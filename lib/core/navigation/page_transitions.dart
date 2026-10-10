import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



/// Subtle fade transition for tab roots.

CustomTransitionPage<void> fadePage(GoRouterState state, Widget child) {

  return CustomTransitionPage<void>(

    key: state.pageKey,

    child: child,

    transitionDuration: const Duration(milliseconds: 250),

    transitionsBuilder: (context, animation, secondary, child) {

      return FadeTransition(

        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),

        child: child,

      );

    },

  );

}



/// Combined slide + fade transition for forward drill-down navigation.

CustomTransitionPage<void> slidePage(GoRouterState state, Widget child) {

  return CustomTransitionPage<void>(

    key: state.pageKey,

    child: child,

    transitionDuration: const Duration(milliseconds: 300),

    reverseTransitionDuration: const Duration(milliseconds: 250),

    transitionsBuilder: (context, animation, secondary, child) {

      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

      return FadeTransition(

        opacity: curved,

        child: SlideTransition(

          position: Tween<Offset>(

            begin: const Offset(0.06, 0),

            end: Offset.zero,

          ).animate(curved),

          child: child,

        ),

      );

    },

  );

}

