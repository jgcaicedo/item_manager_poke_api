import 'package:flutter/material.dart';
import 'package:item_manager_poke_api/utils/utils/responsive.dart';

/// Widget que muestra un indicador de carga circular.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: SizedBox(
        width: responsive.isMobile ? 48 : 64,
        height: responsive.isMobile ? 48 : 64,
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
