# Item Manager Poke API

Item Manager Poke API es una aplicación Flutter que permite a los usuarios crear, listar, ver detalles y eliminar items personalizados, asociando cada item a un Pokémon obtenido desde la PokéAPI. Utiliza Hive para almacenamiento local y Bloc/Cubit para la gestión de estados.

## Características principales
- ✅ **CRUD completo**: Crear, leer, actualizar y eliminar items con validación
- ✅ **Persistencia de formulario**: El texto del nombre se mantiene al navegar entre páginas
- ✅ **Listado de items** con diseño moderno y tarjetas animadas
- ✅ **Creación de items** con formularios intuitivos y preview de Pokémon
- ✅ **Selección de Pokémon** desde la PokéAPI con búsqueda en tiempo real
- ✅ **Visualización de detalles** de cada item con animaciones Hero
- ✅ **Eliminación de items** con confirmación en diálogo
- ✅ **Edición de items** existentes con carga automática de datos
- ✅ **Filtros por tipo de Pokémon** en la lista de items
- ✅ **Animaciones suaves** en todas las transiciones de página
- ✅ **Manejo de estados** de carga y error con indicadores visuales
- ✅ **Diseño responsivo** para móvil y tablet con gradientes y sombras
- ✅ **Tema moderno** con paleta de colores personalizada y tipografía optimizada
- ✅ **Suite completa de pruebas** (11 tests pasando)

## Estructura del proyecto
```
lib/
├── app.dart                 # Configuración de la app y rutas con transiciones
├── main.dart                # Punto de entrada con inicialización de providers
├── cubit/                   # Gestión de estado con Cubit
│   ├── api_cubit/           # Cubit para API de Pokémon (con persistencia de formulario)
│   └── preference_cubit/    # Cubit para items locales
├── data/                    # Capa de datos
│   ├── models/              # Modelos de datos con Hive adapters generados
│   ├── repositories/        # Repositorios (Hive y API)
│   └── sources/             # Fuentes de datos (PokéAPI)
├── utils/                   # Utilidades
│   ├── constants/           # Constantes (temas y configuración)
│   └── utils/               # Utilidades (responsive design)
├── view/                    # Interfaz de usuario
│   ├── api_list_page.dart   # Página de selección de Pokémon
│   ├── item_detail_page.dart # Página de detalles con Hero animations
│   └── pages/               # Páginas principales
└── widget/                  # Widgets reutilizables
    ├── buttons/             # Botones personalizados
    └── widgets/             # Widgets de UI (loading, error)
```

## Instalación y ejecución
1. Clona el repositorio:
   ```sh
   git clone https://github.com/jgcaicedo/item_manager_poke_api.git
   ```
2. Instala dependencias:
   ```sh
   flutter pub get
   ```
3. Genera archivos de Hive:
   ```sh
   flutter pub run build_runner build
   ```
4. Ejecuta la app:
   ```sh
   flutter run
   ```

## Pruebas
Para ejecutar las pruebas:
```sh
flutter test
```

**Estado actual**: ✅ 11/11 tests pasan
- Tests de lógica (Cubits de API y preferencias)
- Tests de widgets (formularios, navegación, persistencia de datos)
- Cobertura completa de funcionalidades críticas

## Tecnologías utilizadas
- **Flutter 3.38.3**: Framework para desarrollo multiplataforma
- **Dart 3.3.3**: Lenguaje de programación con null safety
- **Hive 2.2.3**: Base de datos local NoSQL para persistencia
- **Bloc/Cubit 8.1.3**: Patrón para gestión reactiva de estado
- **GoRouter 12.1.1**: Navegación declarativa con rutas nombradas
- **PokéAPI**: API REST pública para datos de Pokémon
- **Dio 5.3.3**: Cliente HTTP robusto para consumir APIs
- **Flutter Staggered Animations 1.1.1**: Animaciones escalonadas para listas
- **Equatable 2.0.7**: Simplificación de comparación de objetos
- **UUID 4.5.1**: Generación de identificadores únicos
- **Material Design 3**: Sistema de diseño moderno de Google

## Decisiones técnicas
- **Gestión de Estado**: Se usó Cubit en lugar de Bloc completo por simplicidad, manteniendo estados claros (loading, success, error). El estado del ApiCubit incluye persistencia del texto del formulario para mantener la UX fluida.
- **Persistencia**: Hive por su facilidad de uso y rendimiento en Flutter, con modelos anotados para generación automática de adaptadores usando build_runner.
- **Navegación**: GoRouter por su integración con rutas nombradas, manejo de parámetros y transiciones personalizadas. Se optimizó para evitar reconstrucciones innecesarias de páginas.
- **API**: PokéAPI gratuita con mapeo JSON completo usando json_serializable. Se implementó búsqueda en tiempo real y manejo robusto de errores.
- **UI/UX**: Diseño moderno con Material Design 3, gradientes, sombras, animaciones escalonadas y transiciones suaves. Tema personalizado con paleta de colores coherente y tipografía jerárquica.
- **Animaciones**: Flutter Staggered Animations para listas, animaciones Hero para imágenes, transiciones personalizadas en navegación, y animaciones de entrada/salida para mejor experiencia de usuario.
- **Arquitectura**: Clean Architecture con separación de responsabilidades (data, domain, presentation), widgets reutilizables, responsive design y inyección de dependencias.
- **Testing**: Suite completa con tests unitarios para lógica de negocio y tests de widgets para UI crítica. Se agregó test específico para persistencia de formulario.
- **Optimización**: Se eliminaron archivos no utilizados y se optimizó la estructura del proyecto para mejor mantenibilidad.

### Características implementadas:
- CRUD completo con validación
- Integración completa con PokéAPI
- Almacenamiento local con Hive
- Navegación fluida con GoRouter
- Animaciones avanzadas
- Diseño responsivo
- Filtros y búsqueda
- Manejo robusto de errores

## Diagrama de Arquitectura
```
[UI Layer] (Pages/Widgets)
    ↓
[Bloc Layer] (Cubits con estado persistente)
    ↓
[Data Layer] (Repositories, Models, API)
    ↓
[External] (Hive, PokéAPI)
```

## Autores
- **Juan Caicedo** - Desarrollo completo de la aplicación

## Versión
**v1.0.0** - Proyecto completado y listo para producción

## Licencia
Este proyecto está bajo la licencia MIT.
