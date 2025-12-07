import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:item_manager_poke_api/utils/constants/app_theme.dart';
import 'package:item_manager_poke_api/utils/utils/responsive.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_cubit.dart';
import 'package:item_manager_poke_api/cubit/api_cubit/api_state.dart';
import '../widget/widgets/loadling_widget.dart';
import '../widget/widgets/error_widget.dart';

/// Página que muestra la lista de Pokémon obtenidos desde la API.
/// Permite seleccionar un Pokémon para asociarlo a un item.
class ApiListPage extends StatefulWidget {
  const ApiListPage({super.key});

  @override
  ApiListPageState createState() => ApiListPageState();
}

class ApiListPageState extends State<ApiListPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.toLowerCase();
      });
    });

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut),
    );

    _searchAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Pokémon'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/prefs/new'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.isMobile ? responsive.wp(4) : responsive.wp(15),
            vertical: responsive.hp(2),
          ),
          child: Column(
            children: [
              // Campo de búsqueda animado
              FadeTransition(
                opacity: _searchAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar Pokémon',
                      hintText: 'Escribe el nombre...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Contador de resultados
              BlocBuilder<ApiCubit, ApiState>(
                builder: (context, state) {
                  if (state is ApiLoaded) {
                    final filteredItems = state.items.where((item) => item.name.toLowerCase().contains(_query)).toList();
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${filteredItems.length} Pokémon${_query.isNotEmpty ? ' encontrados' : ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),

              const SizedBox(height: 16),

              // Lista de Pokémon
              Expanded(
                child: BlocBuilder<ApiCubit, ApiState>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return const LoadingWidget();
                    } else if (state is ApiLoaded) {
                      final filteredItems = state.items.where((item) => item.name.toLowerCase().contains(_query)).toList();
                      if (filteredItems.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron Pokémon',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Intenta con otro nombre',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                          return AnimationLimiter(
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: crossAxisCount == 1 ? 4 : 2.5,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: crossAxisCount,
                                  child: ScaleAnimation(
                                    child: FadeInAnimation(
                                      child: _buildPokemonCard(context, item),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is ApiError) {
                      return CustomErrorWidget(
                        message: state.message,
                        onRetry: () => context.read<ApiCubit>().fetchPokemons(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonCard(BuildContext context, dynamic item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.read<ApiCubit>().selectPokemon(item);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.name} seleccionado'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go('/prefs/new');
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen del Pokémon con Hero animation
              Hero(
                tag: 'pokemon_form_${item.name}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.sprites.frontDefault,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Información del Pokémon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nombre
                    Text(
                      item.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tipos
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: item.types.map<Widget>((typeSlot) {
                        final typeName = typeSlot.type.name;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.getTypeColor(typeName).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.getTypeColor(typeName).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            typeName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.getTypeColor(typeName),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Icono de selección
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
