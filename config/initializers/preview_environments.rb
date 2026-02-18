# When running in a Roo Code Cloud preview environment, the $ROO_WEB_HOST
# environment variable is injected with the public HTTPS URL for this service.
#
# See: https://docs.roo.codes/preview-environments

if ENV['ROO_WEB_HOST'].present? && !Rails.env.test?
  Rails.application.configure do
    # Allow requests from the preview environment host.
    config.hosts << URI.parse(ENV['ROO_WEB_HOST']).host

    # Allow WebSocket connections from the preview environment host.
    config.action_cable.allowed_request_origins = [ENV['ROO_WEB_HOST']]

    # Allow iframe embedding for Roo Code Cloud preview panel.
    config.action_dispatch.default_headers.delete('X-Frame-Options')
  end
end
