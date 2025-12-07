import '../models/item.dart';

/// Interfaz para el repositorio de items.
/// Define las operaciones CRUD para los items del usuario.
abstract class ItemRepository {
  /// Obtiene todos los items almacenados.
  Future<List<Item>> getAll();

  /// Agrega un nuevo item.
  Future<void> add(Item item);

  /// Elimina un item por su ID.
  Future<void> delete(String id);

  /// Obtiene un item por su ID.
  Item? getById(String id);
}
