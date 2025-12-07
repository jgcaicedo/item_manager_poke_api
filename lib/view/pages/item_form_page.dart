import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../cubit/preference_cubit/preference_cubit.dart';
import '../../cubit/api_cubit/api_cubit.dart';
import '../../data/models/item.dart';
import '../../utils/constants/app_theme.dart';

/// Página de formulario para crear o editar un item.
class ItemFormPage extends StatefulWidget {
  final Item? itemToEdit;

  const ItemFormPage({super.key, this.itemToEdit});

  @override
  ItemFormPageState createState() => ItemFormPageState();
}

class ItemFormPageState extends State<ItemFormPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      _nombreController.text = widget.itemToEdit!.nombre;
    } else {
      // Restaurar texto del estado si existe
      final formText = context.read<ApiCubit>().state.formText;
      if (formText != null && formText.isNotEmpty) {
        _nombreController.text = formText;
      }
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Agregar listener para actualizar el estado cuando cambie el texto
    _nombreController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nombreController.removeListener(_onTextChanged);
    _nombreController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.itemToEdit == null) {
      // Solo guardar el texto para nuevos items
      context.read<ApiCubit>().updateFormText(_nombreController.text);
    }
  }

  void _saveItem() {
    final selectedPokemon = context.read<ApiCubit>().state.selectedPokemon;
    if (_formKey.currentState!.validate()) {
      if (selectedPokemon == null && widget.itemToEdit == null) {
        _showSnackBar('Por favor selecciona un Pokémon', isError: true);
        return;
      }
      late Item item;
      if (widget.itemToEdit != null) {
        // Editar: mantener pokemon, cambiar nombre
        item = Item(
          id: widget.itemToEdit!.id,
          nombre: _nombreController.text,
          imagenUrl: widget.itemToEdit!.imagenUrl,
          apiName: widget.itemToEdit!.apiName,
          tipos: widget.itemToEdit!.tipos,
        );
        context.read<PreferenceCubit>().updateItem(item);
      } else {
        // Crear nuevo
        final tipos = selectedPokemon!.types.map((t) => t.type.name).toList();
        item = Item(
          id: const Uuid().v4(),
          nombre: _nombreController.text,
          imagenUrl: selectedPokemon.sprites.frontDefault,
          apiName: selectedPokemon.name,
          tipos: tipos,
        );
        context.read<PreferenceCubit>().addItem(item);
      }
      _showSnackBar('Item guardado exitosamente');
      // Limpiar el texto del formulario del estado
      context.read<ApiCubit>().updateFormText('');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go('/prefs');
        }
      });
    }
  }

  void _selectPokemon() {
    context.go('/api-list');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPokemon = context.watch<ApiCubit>().state.selectedPokemon;
    final isEditing = widget.itemToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Item' : 'Nuevo Item',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/prefs'),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        // Título
                        Text(
                          isEditing ? 'Editar tu Pokémon' : 'Crear nuevo Pokémon',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Campo de nombre
                        Container(
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
                          child: TextFormField(
                            controller: _nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre del Item',
                              hintText: 'Ej: Mi Charizard',
                              prefixIcon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un nombre';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sección de Pokémon
                        if (!isEditing) ...[
                          Text(
                            'Seleccionar Pokémon',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón de selección
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: selectedPokemon == null
                                    ? [
                                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                      ]
                                    : [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: selectedPokemon != null
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              onPressed: _selectPokemon,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    selectedPokemon == null ? Icons.search : Icons.check_circle,
                                    color: selectedPokemon == null
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    selectedPokemon == null
                                        ? 'Seleccionar Pokémon'
                                        : 'Pokémon: ${selectedPokemon.name}',
                                    style: TextStyle(
                                      color: selectedPokemon == null
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Información del Pokémon seleccionado
                          if (selectedPokemon != null) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(20),
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
                              child: Column(
                                children: [
                                  // Imagen del Pokémon
                                  Hero(
                                    tag: 'pokemon_form_${selectedPokemon.name}',
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          selectedPokemon.sprites.frontDefault,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Theme.of(context).colorScheme.surfaceVariant,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Nombre
                                  Text(
                                    selectedPokemon.name.toUpperCase(),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Tipos
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: selectedPokemon.types.map((typeSlot) {
                                      final typeName = typeSlot.type.name;
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppTheme.getTypeColor(typeName).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: AppTheme.getTypeColor(typeName).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          typeName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.getTypeColor(typeName),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ] else ...[
                          // Modo edición - mostrar info del Pokémon actual
                          Container(
                            padding: const EdgeInsets.all(20),
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
                            child: Column(
                              children: [
                                Text(
                                  'Pokémon actual',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Hero(
                                  tag: 'pokemon_${widget.itemToEdit!.id}',
                                  child: Container(
                                    width: 100,
                                    height: 100,
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
                                        widget.itemToEdit!.imagenUrl,
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
                                const SizedBox(height: 12),

                                Text(
                                  widget.itemToEdit!.apiName.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  alignment: WrapAlignment.center,
                                  children: widget.itemToEdit!.tipos.map((type) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.getTypeColor(type).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppTheme.getTypeColor(type).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        type,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.getTypeColor(type),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Botón guardar
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _saveItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isEditing ? Icons.save : Icons.add,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isEditing ? 'Actualizar Item' : 'Guardar Item',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
