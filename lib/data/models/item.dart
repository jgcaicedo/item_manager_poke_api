import 'package:hive/hive.dart';
part 'item.g.dart';

@HiveType(typeId: 0)
/// Modelo que representa un item personalizado del usuario.
class Item {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nombre;

  @HiveField(2)
  final String imagenUrl;

  @HiveField(3)
  final String apiName;

  @HiveField(4)
  final List<String> tipos;

  Item({
    required this.id,
    required this.nombre,
    required this.imagenUrl,
    required this.apiName,
    required this.tipos,
  });

}