# Backend Contract Testing

Use this guide for REST, GraphQL, Firebase/Supabase wrappers, or custom backend integration.

## Required artifacts

- API contract: OpenAPI, GraphQL schema, or documented endpoint table.
- DTO examples for success and error responses.
- Mock server or fake repository.
- Versioning and compatibility notes.
- Breaking change checklist.

## Workflow

1. Define endpoint contract before UI implementation.
2. Create DTOs and mapping tests.
3. Create fake repository for UI/state tests.
4. Create contract tests for important endpoints.
5. Validate error shapes, pagination, auth expiry, and rate limits.
6. Document migration steps when backend changes.

## Flutter rules

- Widgets consume domain models and view state, not raw DTOs.
- Repositories translate API failures into typed domain failures.
- Auth refresh and retry behavior live in infrastructure/networking.
- Pagination cursors and filters are explicit value objects when complex.

## Compatibility checklist

- Old client with new backend.
- New client with old cached data.
- Expired auth token.
- Missing optional fields.
- Unknown enum values.
- Rate limit response.
- Offline transition during request.
