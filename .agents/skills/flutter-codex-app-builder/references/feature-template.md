# Feature template

Use this reference when adding a new feature to a Flutter app. Adapt names to the existing repository style.

## Standard files

For feature `<feature>`:

```text
lib/features/<feature>/
  data/
    datasources/<feature>_remote_data_source.dart
    dto/<feature>_dto.dart
    repositories/<feature>_repository_impl.dart
  domain/
    entities/<feature>.dart
    failures/<feature>_failure.dart
    repositories/<feature>_repository.dart
    usecases/get_<feature>.dart
  presentation/
    controllers/<feature>_controller.dart
    screens/<feature>_screen.dart
    widgets/
test/features/<feature>/
  domain/get_<feature>_test.dart
  presentation/<feature>_screen_test.dart
```

Use plural names when the feature is naturally a collection, for example `orders`, `messages`, or `notifications`.

## Domain entity

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<feature>.freezed.dart';

@freezed
class <Feature> with _$<Feature> {
  const factory <Feature>({
    required String id,
    required String title,
  }) = _<Feature>;
}
```

If the entity is simple and the project avoids generated domain code, use a hand-written immutable class.

## DTO

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<feature>_dto.freezed.dart';
part '<feature>_dto.g.dart';

@freezed
class <Feature>Dto with _$<Feature>Dto {
  const factory <Feature>Dto({
    required String id,
    required String title,
  }) = _<Feature>Dto;

  factory <Feature>Dto.fromJson(Map<String, dynamic> json) => _$<Feature>DtoFromJson(json);
}
```

Keep mapping to domain in the data layer:

```dart
extension <Feature>DtoMapper on <Feature>Dto {
  <Feature> toDomain() => <Feature>(id: id, title: title);
}
```

## Repository interface

```dart
abstract interface class <Feature>Repository {
  Future<List<<Feature>>> fetchItems();
}
```

Return `Future<Result<T, Failure>>` or `Either<Failure, T>` only if the project already uses that pattern. Otherwise, typed exceptions/failures plus clear repository tests are acceptable.

## Riverpod controller

```dart
final <feature>ControllerProvider =
    AsyncNotifierProvider<<Feature>Controller, List<<Feature>>>(<Feature>Controller.new);

class <Feature>Controller extends AsyncNotifier<List<<Feature>>> {
  @override
  Future<List<<Feature>>> build() {
    return ref.watch(<feature>RepositoryProvider).fetchItems();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(<feature>RepositoryProvider).fetchItems(),
    );
  }
}
```

## Screen pattern

```dart
class <Feature>Screen extends ConsumerWidget {
  const <Feature>Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(<feature>ControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('<Feature>')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          message: 'Something went wrong.',
          onRetry: () => ref.read(<feature>ControllerProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) return const _EmptyState();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ListTile(title: Text(items[index].title)),
          );
        },
      ),
    );
  }
}
```

## Route wiring

Add routes near existing route definitions. For go_router:

```dart
GoRoute(
  name: RouteNames.<feature>,
  path: '/<feature>',
  builder: (context, state) => const <Feature>Screen(),
),
```

For guarded screens, put auth checks in centralized redirect logic, not inside every screen.

## Test checklist

- Controller emits loading, success, error, and refresh states.
- Repository maps DTOs and failures correctly.
- Screen renders loading, empty, error, and success states.
- Route is reachable and redirects correctly when applicable.
