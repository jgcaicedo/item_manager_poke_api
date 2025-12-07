import 'package:flutter_bloc/flutter_bloc.dart';
import 'preference_state.dart';
import '../../data/models/item.dart';
import '../../data/repositories/item_repository.dart';

/// Cubit encargado de manejar la lógica de negocio para los items del usuario.
/// Permite agregar, eliminar y obtener items usando Hive como almacenamiento local.
class PreferenceCubit extends Cubit<PreferenceState> {
  final ItemRepository repository;

  PreferenceCubit(this.repository) : super(PreferenceInitial());

  void loadItems() async {
    emit(PreferenceLoading());
    try {
      final items = await repository.getAll();
      emit(PreferenceLoaded(items));
    } catch (e) {
      emit(const PreferenceError('Error al cargar items'));
    }
  }

  void addItem(Item item) async {
    try {
      await repository.add(item);
      loadItems(); // refrescar lista
    } catch (e) {
      emit(PreferenceError('Error al guardar item: $e'));
    }
  }

  void updateItem(Item item) async {
    try {
      await repository.add(item); // put actualiza si existe
      loadItems();
    } catch (e) {
      emit(PreferenceError('Error al actualizar item: $e'));
    }
  }

  void deleteItem(String id) async {
    await repository.delete(id);
    loadItems(); // refrescar lista
  }

  Item? getItemById(String id) {
    return repository.getById(id);
  }
}
