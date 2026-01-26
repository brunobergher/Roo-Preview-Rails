# Preview Rails

## Setup

```bash
# Install Ruby
mise install

# Install dependencies
bundle install

# Start PostgreSQL and Redis
docker compose up -d

# Create database
bin/rails db:create db:migrate
```

## Run

```bash
# Start everything (web server + Sidekiq)
bin/dev
```

- **App**: http://localhost:3000
- **Sidekiq**: http://localhost:3000/sidekiq
