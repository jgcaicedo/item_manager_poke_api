import 'package:hive/hive.dart';
import '../models/item.dart';
import 'item_repository.dart';

/// Implementación del repositorio de items usando Hive.
class HiveItemRepository implements ItemRepository {
  static const String _boxName = 'items';

  late Box<Item> _box;

  /// Inicializa el repositorio abriendo la caja de Hive.
  Future<void> init() async {
    try {
      _box = await Hive.openBox<Item>(_boxName);
    } catch (e) {
      // Handle error, perhaps delete and reopen
      await Hive.deleteBoxFromDisk(_boxName);
      _box = await Hive.openBox<Item>(_boxName);
    }
  }

  @override
  Future<List<Item>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> add(Item item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Item? getById(String id) {
    return _box.get(id);
  }
}
