# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Setup
mise install                    # Install Ruby 3.3.7
bundle install                  # Install dependencies
docker compose up -d            # Start PostgreSQL and Redis
bin/rails db:create db:migrate  # Create database

# Development
bin/dev                         # Start all services (web + Sidekiq + Tailwind watcher)

# Individual services
bin/rails server -p 3000        # Web server only
bundle exec sidekiq -C config/sidekiq.yml  # Sidekiq only
bin/rails tailwindcss:watch     # Tailwind CSS watcher only

# Database
bin/rails db:migrate            # Run migrations
bin/rails db:rollback           # Rollback last migration

# Tests
bin/rails test                  # Run all tests
bin/rails test test/models/counter_test.rb  # Run single test file
bin/rails test test/models/counter_test.rb:10  # Run specific test by line

# Code quality
bundle exec rubocop             # Run linter
bundle exec rubocop -a          # Auto-fix lint issues
bundle exec brakeman            # Security analysis
```

## Architecture

Rails 8.0 app with PostgreSQL, Redis, Sidekiq, and Turbo Streams for real-time updates.

**Key patterns:**
- **Turbo Streams for real-time**: Background jobs broadcast UI updates via `Turbo::StreamsChannel.broadcast_replace_to`. See `IncrementCounterJob` for the pattern.
- **Stimulus controllers**: JavaScript in `app/javascript/controllers/` using importmaps (no Node.js build step).
- **Named singleton pattern**: `Counter.clicks` returns a find-or-create singleton record. Uses `with_lock` for thread-safe increments.

**Services:**
- Web: Puma on port 3000
- Background jobs: Sidekiq (dashboard at `/sidekiq`)
- CSS: Tailwind CSS 4.x with watch mode

**Routes:**
- `GET /` - Home page with counter
- `POST /increment` - Enqueues `IncrementCounterJob`
- `GET /ping` - Returns pong (used by ping_controller.js)
- `GET /sidekiq` - Sidekiq dashboard
- `GET /up` - Health check
