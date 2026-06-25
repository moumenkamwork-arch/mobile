# Flutter architecture reference

## Default package stack

Use these packages when starting a new complex app or when the project has no existing convention:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1
  dio: ^5.8.0+1
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.15
  freezed: ^2.5.8
  json_serializable: ^6.9.4
  mocktail: ^1.0.4
```

Before adding versions, inspect the repo and prefer versions compatible with the existing Flutter SDK. The package versions above are defaults, not hard requirements.

## Folder structure

Prefer feature-first organization:

```text
lib/
  app.dart
  main.dart
  core/
    config/
    errors/
    network/
    storage/
    utils/
  routing/
    app_router.dart
    route_names.dart
  theme/
    app_theme.dart
  l10n/
  features/
    auth/
      data/
        datasources/
        dto/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        controllers/
        screens/
        widgets/
```

Use a simpler structure for small apps, but keep boundaries clear as complexity grows.

## Layer responsibilities

### presentation

- Flutter widgets, screens, visual state, forms, animations, semantics.
- Riverpod controllers/providers that expose UI state.
- No direct Dio calls, SQL, Firebase SDK calls, or DTO parsing in widgets.

### application

Optional layer for orchestration when flows span multiple use cases or features. Use when a controller would otherwise become too large.

### domain

- Entities, value objects, failures, repository interfaces, use cases.
- No Flutter, Dio, JSON, Firebase, or storage imports.
- Keep business rules testable with pure Dart tests.

### data

- API clients, DTOs, local data sources, repository implementations, mappers.
- Convert remote/local exceptions into domain failures.
- Keep serialization and transport details here.

## Riverpod rules

- Use providers for dependency wiring instead of global service locators.
- Prefer `AsyncNotifier` for screen-level async state with refresh/retry/mutation logic.
- Prefer immutable state objects for complex screens.
- Use `ref.watch` in widgets, `ref.read` for callbacks, and avoid watching broad providers unnecessarily.
- Keep provider names specific and discoverable, e.g. `ordersRepositoryProvider`, `ordersControllerProvider`.
- Use `ProviderScope` overrides in tests.

Example:

```dart
final ordersControllerProvider =
    AsyncNotifierProvider<OrdersController, List<Order>>(OrdersController.new);

class OrdersController extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async {
    final repository = ref.watch(ordersRepositoryProvider);
    return repository.fetchOrders();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(ordersRepositoryProvider).fetchOrders());
  }
}
```

## go_router rules

- Keep route names/paths centralized.
- Use shell routes for tabbed apps.
- Keep auth redirects small and provider-driven.
- Parse route params at the route boundary and validate them before building screens.
- Use deep-link friendly paths for complex apps.

## Networking and failures

- Configure Dio with base URL, connect/receive/send timeouts, JSON headers, and interceptors as needed.
- Use cancellable requests for search or fast-changing screens where practical.
- Map HTTP status, timeouts, parsing errors, and offline cases into typed domain failures.
- Show human-friendly error messages in presentation, but keep raw diagnostics in logs.

## UI and performance

- Prefer `const` constructors and small widgets.
- Use `ListView.builder`, slivers, pagination, and image caching for large content.
- Avoid expensive work in `build`.
- Debounce search input and cancel stale requests.
- Use responsive constraints instead of fixed desktop/mobile assumptions.
- Support text scaling, semantics, keyboard navigation where relevant, and contrast-safe themes.

## Security and configuration

- Never hardcode production secrets, API keys, tokens, private endpoints, or signing material.
- Prefer environment config through `--dart-define`, secure storage for tokens, and platform configuration files managed outside source when appropriate.
- Treat logs as user-visible in production; avoid logging secrets or PII.

## Testing expectations

For complex features, add at least one representative test in each relevant layer:

- domain use case unit test.
- repository test with mocked data source/client.
- provider/controller test using `ProviderContainer` overrides.
- widget test for loading/success/error states.
- routing test for guarded navigation when auth or deep links matter.

Use golden tests only when the project already supports them or visual stability matters.
