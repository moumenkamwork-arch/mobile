# AI App Pack

Use this for apps that call AI services, generate content, summarize user data, use embeddings, voice/image models, or AI agents.

## AI architecture

- Wrap providers behind `AiService` interfaces.
- Keep prompts/templates versioned and testable.
- Add request/response DTOs and error mapping.
- Add rate limiting, cancellation, timeout, retry, and fallback states.
- Stream responses where UX benefits, with partial-output state.
- Cache only when privacy and product requirements allow.

## Safety and privacy

- Disclose when user data is sent to AI providers.
- Avoid sending secrets, credentials, payment data, or unnecessary PII.
- Add moderation for user-generated or public AI output.
- Provide reporting/feedback for unsafe output when relevant.
- Add data deletion/export considerations for saved AI history.
- Track token/cost usage with privacy-safe telemetry.

## UX states

- Preparing prompt.
- Generating/streaming.
- Retryable failure.
- Rate limited.
- Unsafe output blocked.
- Partial output saved or discarded.
- User edit/approve before publish for high-risk content.
