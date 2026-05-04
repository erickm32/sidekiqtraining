# sidekiqtraining — Context for Claude Code

## Vision

A Rails API that receives **event records** — logs of actions performed by the user (e.g., "ran 5km", "read 30 pages"). Events are submitted via REST API, processed asynchronously by Sidekiq workers, and consumed by a Flutter Android app.

The project serves a dual purpose:
1. **Product**: a personal activity tracker with async processing
2. **Learning**: a hands-on Sidekiq training ground, progressing from simple to advanced patterns

## Tech Stack

- **Rails 7.2** + PostgreSQL + Redis
- **Sidekiq 7.3** — background job processing
- **RSpec** + FactoryBot + Shoulda Matchers — test suite
- **ActiveJob** adapter set to Sidekiq
- Dev process managed via `bin/dev` (Procfile.dev: rails on port 5000 + sidekiq worker)

## Domain Model

### Category
- `name` (string, required)
- `has_many :events, dependent: :restrict_with_error`

### Event
- `name` (string, required) — what happened ("corri 5km")
- `category_id` (FK → categories)
- `observation` (text, optional) — free-form note
- `timestamp` (datetime, optional) — when it happened (defaults to created_at if nil)
- `status` (string, enum) — `pending | processing | processed | failed` (default: `pending`)
- `processed_at` (datetime) — set when Sidekiq finishes processing

## API Endpoints (JSON)

Base path: `/api`

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/events` | List all events |
| GET | `/api/events/:id` | Get single event |
| POST | `/api/events` | Create event → enqueues `EventProcessorJob` |
| PATCH/PUT | `/api/events/:id` | Update event |
| DELETE | `/api/events/:id` | Delete event |
| GET | `/api/categories` | List all categories |
| GET | `/api/categories/:id` | Get single category |
| POST | `/api/categories` | Create category |
| PATCH/PUT | `/api/categories/:id` | Update category |
| DELETE | `/api/categories/:id` | Delete category (blocked if events exist) |

Full OpenAPI contract: see `openapi.yml` in project root.

## Sidekiq Roadmap

### Level 1 — Async Event Processing ✅ DONE
- `EventProcessorJob` — enqueued on `POST /api/events`
- Transitions: `pending → processing → processed`
- `processed_at` set on completion; `RecordNotFound` handled gracefully
- Tests: `spec/jobs/event_processor_job_spec.rb`

### Level 2 — Chained Jobs + Email Notification (next)
- `EventMailer#processed_notification` — confirms event was processed
- `EventNotificationJob` — enqueued by `EventProcessorJob` on success
- Uses `deliver_later` (Sidekiq-backed)
- Concept learned: **job chaining**

### Level 3 — Retry Logic + Failure Handling
- `sidekiq_options retry: 3` on `EventProcessorJob`
- `sidekiq_retries_exhausted` callback → sets status to `failed`
- Structured logging with `Rails.logger` per attempt
- Concept learned: **resilience, dead job queue**

### Level 4 — Sidekiq Web UI + Priority Queues
- Mount `Sidekiq::Web` at `/sidekiq`
- Queues: `critical`, `default` (events), `low` (reports)
- Update `config/sidekiq.yml` with weights
- Concept learned: **observability, queue priorities**

### Level 5 — Scheduled Jobs (sidekiq-cron)
- Add gem `sidekiq-cron`
- `DailyReportJob` — counts events by status, logs summary
- `config/schedule.yml` + initializer
- Concept learned: **cron jobs, Sidekiq lifecycle hooks**

## Development Setup

```bash
# Start web + worker together
bin/dev

# Run only tests
bundle exec rspec

# Run specific specs
bundle exec rspec spec/jobs/ spec/requests/api/
```

## Flutter Consumer App

A Flutter Android app consumes this API. Key contract points:
- `POST /api/events` returns `201 Created` with the event JSON (status will be `pending` initially)
- Poll `GET /api/events/:id` to check when `status` transitions to `processed`
- Error responses use `{ "error": "message" }` for not-found; field-keyed hashes for validation errors
- See `openapi.yml` for full schema — use `openapi-generator` to generate a Dart client:
  ```bash
  openapi-generator generate -i openapi.yml -g dart-dio -o ../flutter_app/lib/api
  ```

## Key Files

| File | Purpose |
|------|---------|
| `app/jobs/event_processor_job.rb` | Core async job (Level 1) |
| `app/jobs/hello_job.rb` | Original demo job (kept for reference) |
| `config/sidekiq.yml` | Worker concurrency and queue config |
| `spec/jobs/event_processor_job_spec.rb` | Job unit tests |
| `spec/requests/api/event_spec.rb` | API integration tests |
| `openapi.yml` | API contract for Flutter client generation |
