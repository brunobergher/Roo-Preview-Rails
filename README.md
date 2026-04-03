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

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `SECRET_SAUCE` | **Yes** | Any string value. Displayed on the home page. The app will refuse to boot without it. |

## Run

```bash
# Start everything (web server + Sidekiq)
SECRET_SAUCE=ketchup bin/dev
```

- **App**: http://localhost:3000
- **Sidekiq**: http://localhost:3000/sidekiq

## Roo Code Cloud

To run this app in a preview environment, use this configuration:

```yaml
name: Rails App (Dual services)
description: A basic Rails app demo for preview environments.
repositories:
  - repository: brunobergher/Roo-Preview-Rails
    commands:
      - name: Install dependencies
        run: bundle install
        timeout: 120
      - name: Setup database
        run: bin/rails db:create db:migrate
      - name: Build Tailwind CSS
        run: bin/rails tailwindcss:build
      - name: Start Tailwind watcher
        run: bin/rails tailwindcss:watch
        detached: true
        logfile: /tmp/tailwind.log
      - name: Start Sidekiq
        run: bundle exec sidekiq -C config/sidekiq.yml
        detached: true
        logfile: /tmp/sidekiq.log
      - name: Start Rails server
        run: bin/rails server -p 3000 -b 0.0.0.0
        detached: true
        logfile: /tmp/web.log
      - name: Start sinatra server
        run: bin/dev server -p 3001 -b 0.0.0.0
        detached: true
        logfile: /tmp/web.log

ports:
  - name: RAILS
    port: 3000
  - name: SINATRA
    port: 3001
services:
  - postgres17
  - redis7
```

<img width="1494" height="1161" alt="Preview" src="https://github.com/user-attachments/assets/f5348c8b-297d-4de8-8481-840744937b39" />

## Fun Fact

1 + 1 = **2**
