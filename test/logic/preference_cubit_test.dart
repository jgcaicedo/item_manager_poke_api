import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_manager_poke_api/cubit/preference_cubit/preference_cubit.dart';
import 'package:item_manager_poke_api/cubit/preference_cubit/preference_state.dart';
import 'package:item_manager_poke_api/data/models/item.dart';
import 'package:item_manager_poke_api/data/repositories/item_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockItemRepository extends Mock implements ItemRepository {}

void main() {
  late PreferenceCubit cubit;
  late MockItemRepository mockRepo;

  final testItem = Item(
    id: 'test-id',
    nombre: 'Mi item',
    imagenUrl: 'https://url.png',
    apiName: 'pikachu',
    tipos: ['electric'],
  );

  setUp(() {
    mockRepo = MockItemRepository();
    cubit = PreferenceCubit(mockRepo);
  });

  group('PreferenceCubit', () {
    test('initial state is PreferenceInitial', () {
      expect(cubit.state, PreferenceInitial());
    });

    blocTest<PreferenceCubit, PreferenceState>(
      'emits [Loading, Loaded] when loadItems succeeds',
      build: () {
        when(() => mockRepo.getAll()).thenAnswer((_) async => [testItem]);
        return cubit;
      },
      act: (cubit) => cubit.loadItems(),
      expect: () => [
        PreferenceLoading(),
        PreferenceLoaded([testItem]),
      ],
    );

    blocTest<PreferenceCubit, PreferenceState>(
      'emits [Loading, Loaded] after addItem',
      build: () {
        when(() => mockRepo.add(testItem)).thenAnswer((_) async {});
        when(() => mockRepo.getAll()).thenAnswer((_) async => [testItem]);
        return cubit;
      },
      act: (cubit) => cubit.addItem(testItem),
      expect: () => [
        PreferenceLoading(),
        PreferenceLoaded([testItem]),
      ],
    );

    blocTest<PreferenceCubit, PreferenceState>(
      'emits [Loading, Loaded] after deleteItem',
      build: () {
        when(() => mockRepo.delete('test-id')).thenAnswer((_) async {});
        when(() => mockRepo.getAll()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.deleteItem('test-id'),
      expect: () => [
        PreferenceLoading(),
        const PreferenceLoaded([]),
      ],
    );

    test('getItemById returns correct item', () {
      when(() => mockRepo.getById('test-id')).thenReturn(testItem);
      final result = cubit.getItemById('test-id');
      expect(result, testItem);
    });
  });
}
