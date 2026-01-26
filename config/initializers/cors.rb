Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # In preview environments, ROO_WEB_HOST contains the public URL.
    # Fall back to ALLOWED_ORIGINS or "*" for local development.
    allowed = if ENV['ROO_WEB_HOST'].present?
      [ENV['ROO_WEB_HOST']]
    else
      ENV.fetch('ALLOWED_ORIGINS', '*').split(',')
    end

    origins allowed

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
