# Complete Error Pages Strategy

## Overview

This document provides a comprehensive strategy for implementing all error pages (404, 422, 500) in a consistent, user-friendly way that matches the application's design system.

## Error Pages Summary

| Error | Name | When It Occurs | User Feels | Priority |
|-------|------|---------------|------------|----------|
| **404** | Not Found | User requests non-existent URL | "I might have typed wrong" | High |
| **422** | Unprocessable Entity | Form validation fails | "My input was invalid" | Medium |
| **500** | Internal Server Error | Application crashes | "Something is broken" | Critical |

## Implementation Strategy Matrix

| Feature | 404 Page | 422 Page | 500 Page |
|---------|----------|----------|----------|
| **Static Fallback** | Optional | Optional | **Required** |
| **Dynamic Page** | **Recommended** | **Recommended** | Optional |
| **Can Use Rails** | ✅ Yes | ✅ Yes | ⚠️ Maybe |
| **Can Query DB** | ✅ Yes | ✅ Yes | ❌ No |
| **Must Be Simple** | No | No | **Yes** |
| **CDN CSS Acceptable** | No (use build) | No (use build) | **Yes** |

## Design System Consistency

All error pages should share:

### Visual Design
```css
Background: bg-gray-50
Primary Color: red-600 (#DC2626)
Text: text-gray-800 / text-gray-500
Layout: Centered, vertical and horizontal
Container: White card with shadow
Spacing: Generous padding (p-8)
```

### Typography Scale
```
Emoji/Icon: text-6xl or text-7xl
Heading: text-5xl font-bold
Subheading: text-xl
Body: text-base text-gray-600
```

### Component Pattern
```
┌─────────────────────────────────┐
│   Centered Container            │
│                                 │
│        🔍 [Emoji]               │
│                                 │
│     [Error Code]                │
│     Page Not Found              │
│                                 │
│   [Helpful explanation text]    │
│                                 │
│   [Primary Action Button]       │
│   [Secondary Action Link]       │
│                                 │
└─────────────────────────────────┘
```

## Page-Specific Content

### 404 Not Found

**Emoji:** 🔍 or 🗺️  
**Heading:** "404 - Page Not Found"  
**Tone:** Helpful and friendly  
**Message:** "The page you're looking for doesn't exist or has been moved."

**User Actions:**
1. **Primary:** "Go Home" button → `/`
2. **Secondary:** "Search" (optional)
3. **Tertiary:** Link to sitemap or main sections

**Implementation:** Dynamic page via ErrorsController (application works fine)

### 422 Unprocessable Entity

**Emoji:** ⚠️ or 📝  
**Heading:** "422 - Invalid Request"  
**Tone:** Instructive and helpful  
**Message:** "The information you submitted couldn't be processed. Please check your input and try again."

**User Actions:**
1. **Primary:** "Go Back" button → `history.back()`
2. **Secondary:** "Go Home" button → `/`
3. **Tertiary:** Link to help/documentation

**Implementation:** Dynamic page via ErrorsController (application works fine)

**Special Note:** Often these errors show inline validation, so this page might be rare

### 500 Internal Server Error

**Emoji:** ⚠️ or 🔧  
**Heading:** "500 - Server Error"  
**Tone:** Apologetic and reassuring  
**Message:** "We're sorry! Something went wrong on our end. Our team has been notified and is working to fix it."

**User Actions:**
1. **Primary:** "Try Again" button → Reload page
2. **Secondary:** "Go Home" button → `/`
3. **Tertiary:** "Contact Support" (optional)
4. **Show:** Error reference ID (if possible)

**Implementation:** Hybrid approach (static fallback + optional dynamic)

## Implementation Roadmap

### Phase 1: Core Error Handling Infrastructure
```
[x] Research existing error pages
[x] Design error page system architecture
[ ] Create ErrorsController
[ ] Configure routes for error pages
[ ] Update config/application.rb
```

### Phase 2: 404 Page (Highest User Impact)
```
[ ] Create app/views/errors/not_found.html.erb
[ ] Style with Tailwind using application layout
[ ] Add navigation buttons
[ ] Test routing to 404 page
```

### Phase 3: 500 Page (Most Critical)
```
[ ] Design enhanced public/500.html with Tailwind CDN
[ ] Create static fallback that always works
[ ] Optionally create dynamic app/views/errors/internal_server_error.html.erb
[ ] Test fallback behavior
[ ] Test with various failure scenarios
```

### Phase 4: 422 Page (Completeness)
```
[ ] Create app/views/errors/unprocessable_entity.html.erb
[ ] Style consistently with other error pages
[ ] Add back navigation
[ ] Test with form validation failures
```

### Phase 5: Testing & Polish
```
[ ] Manual testing of all error pages
[ ] Cross-browser testing
[ ] Mobile responsiveness testing
[ ] Accessibility review
[ ] Error tracking integration (optional)
```

## File Structure

```
app/
├── controllers/
│   └── errors_controller.rb              # NEW
├── views/
│   └── errors/
│       ├── not_found.html.erb            # NEW (404)
│       ├── unprocessable_entity.html.erb # NEW (422)
│       └── internal_server_error.html.erb # NEW (500, optional)
config/
├── application.rb                         # UPDATED
├── routes.rb                              # UPDATED
└── environments/
    └── development.rb                     # OPTIONALLY UPDATED
public/
├── 404.html                               # Can remove after dynamic works
├── 422.html                               # Can remove after dynamic works
└── 500.html                               # KEEP and ENHANCE (critical fallback)
```

## ErrorsController Implementation

```ruby
# app/controllers/errors_controller.rb
class ErrorsController < ApplicationController
  # Don't require authentication for error pages
  skip_before_action :authenticate_user!, if: -> { defined?(authenticate_user!) }
  
  # For 500 errors, skip CSRF protection as request might be malformed
  skip_before_action :verify_authenticity_token, only: :internal_server_error
  
  layout 'application'
  
  # 404 - Not Found
  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.json { render json: { error: 'Not found' }, status: :not_found }
      format.all { render status: :not_found, body: nil }
    end
  end
  
  # 422 - Unprocessable Entity
  def unprocessable_entity
    respond_to do |format|
      format.html { render status: :unprocessable_entity }
      format.json { render json: { error: 'Unprocessable entity' }, status: :unprocessable_entity }
      format.all { render status: :unprocessable_entity, body: nil }
    end
  end
  
  # 500 - Internal Server Error
  def internal_server_error
    # Keep this EXTREMELY simple - app might be broken
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.json { render json: { error: 'Internal server error' }, status: :internal_server_error }
      format.all { render status: :internal_server_error, body: nil }
    end
  rescue => e
    # If this fails, Rails will serve public/500.html automatically
    raise
  end
end
```

## Routes Configuration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ... existing routes ...
  
  # Error pages - must be at the end
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  
  # Catch-all route for undefined paths (optional, but recommended)
  # This ensures any undefined route shows our custom 404
  match '*path', to: 'errors#not_found', via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/action_cable'
  }
end
```

## Application Configuration

```ruby
# config/application.rb
module PreviewRails
  class Application < Rails::Application
    # ... existing config ...
    
    # Use routes for error handling instead of public/*.html
    config.exceptions_app = routes
    
    # Optional: Specify which exceptions map to which status codes
    config.action_dispatch.rescue_responses.merge!(
      'YourCustomException' => :not_found,
      'AnotherException' => :unprocessable_entity
    )
  end
end
```

## Testing Strategy

### Manual Testing Checklist

#### 404 Testing
```
[ ] Navigate to /non-existent-page
[ ] Verify custom 404 page displays
[ ] Click "Go Home" button
[ ] Test on mobile and desktop
[ ] Test with different URL patterns
```

#### 422 Testing
```
[ ] Navigate directly to /422
[ ] Verify page displays correctly
[ ] Test with actual invalid form submission (if forms exist)
[ ] Verify "Go Back" works
```

#### 500 Testing
```
[ ] Add test route that raises exception
[ ] Verify dynamic error page shows (if implemented)
[ ] Stop database to simulate real failure
[ ] Verify static public/500.html fallback works
[ ] Test that static page loads without Rails
[ ] Open public/500.html directly in browser
```

### Automated Testing

```ruby
# test/controllers/errors_controller_test.rb
require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should show 404 page" do
    get '/404'
    assert_response :not_found
    assert_select 'h1', /404|not found/i
  end
  
  test "should show 422 page" do
    get '/422'
    assert_response :unprocessable_entity
    assert_select 'h1', /422|unprocessable/i
  end
  
  test "should show 500 page" do
    get '/500'
    assert_response :internal_server_error
    assert_select 'h1', /500|server error/i
  end
  
  test "should handle undefined routes with 404" do
    get '/this-definitely-does-not-exist'
    assert_response :not_found
  end
end
```

## Mobile Responsiveness

All error pages must be mobile-friendly:

```html
<!-- Responsive container -->
<div class="min-h-screen flex items-center justify-center p-4 sm:p-8">
  <div class="max-w-md w-full bg-white rounded-lg shadow-lg p-6 sm:p-8">
    <!-- Content scales appropriately -->
    <div class="text-6xl sm:text-7xl">🔍</div>
    <h1 class="text-3xl sm:text-5xl">404</h1>
    <!-- Buttons stack on mobile -->
    <div class="flex flex-col sm:flex-row gap-4">
      <button class="w-full sm:w-auto">Go Home</button>
    </div>
  </div>
</div>
```

## Accessibility Considerations

### ARIA Labels
```html
<main role="main" aria-label="Error page">
  <h1 id="error-title">404 - Page Not Found</h1>
  <p aria-describedby="error-title">...</p>
</main>
```

### Semantic HTML
- Use `<main>` for content
- Proper heading hierarchy (h1 → h2)
- Button vs link (buttons for actions, links for navigation)

### Color Contrast
- Ensure text meets WCAG AA standards
- Test with contrast checker
- Don't rely solely on color for meaning

### Keyboard Navigation
- All buttons/links must be keyboard accessible
- Clear focus indicators
- Logical tab order

## Error Monitoring Integration

### Optional: Add Error Tracking

```ruby
# Gemfile
gem 'sentry-ruby'
gem 'sentry-rails'

# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = Rails.env
  config.enabled_environments = %w[production staging]
end

# app/controllers/errors_controller.rb
def internal_server_error
  # Sentry automatically captures errors
  # You can add custom context
  Sentry.set_context('error_page', {
    accessed_at: Time.current,
    user_agent: request.user_agent
  })
  
  render status: :internal_server_error
rescue => e
  Sentry.capture_exception(e)
  raise
end
```

## Content Guidelines

### Writing Error Messages

**Do:**
- ✅ Be empathetic and apologetic
- ✅ Explain what happened in simple terms
- ✅ Tell users what they can do
- ✅ Use active voice
- ✅ Be concise

**Don't:**
- ❌ Use technical jargon
- ❌ Blame the user
- ❌ Show stack traces (in production)
- ❌ Be vague ("an error occurred")
- ❌ Make jokes (unless it fits your brand)

### Example Messages

**Good 404:**
> "We couldn't find the page you're looking for. It might have been moved or deleted. Try going back home or use the search below."

**Bad 404:**
> "Error 404: Resource not found in database. Stack trace: ..."

**Good 500:**
> "Something went wrong on our end. We're sorry for the inconvenience and our team is working to fix it. Please try again in a few minutes."

**Bad 500:**
> "Fatal error in main.rb line 42: undefined method 'foo' for nil:NilClass"

## Browser Support

Test error pages in:
- ✅ Chrome/Edge (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Mobile Safari (iOS)
- ✅ Chrome Mobile (Android)

**Note:** Since 500.html uses CDN, it should work everywhere. Dynamic pages use application's normal browser support.

## Performance Considerations

### Static 500 Page
- Must load in < 1 second
- Minimize external dependencies
- Inline critical CSS if possible
- Use CDN for Tailwind (fast global delivery)

### Dynamic Pages (404, 422)
- Use application's normal asset pipeline
- Cache if possible
- Keep queries minimal
- No heavy computations

## Security Considerations

### Don't Leak Information
- ❌ Don't show stack traces in production
- ❌ Don't reveal file paths
- ❌ Don't show database queries
- ❌ Don't expose server information

### Rate Limiting (Optional)
Consider rate limiting error pages to prevent:
- Information gathering attacks
- DoS attempts via 404 spam

### CSRF Protection
- Skip CSRF for 500 errors (request might be malformed)
- Keep CSRF for 404/422 (application is working)

## Deployment Checklist

Before deploying error pages:

```
[ ] All error pages render correctly locally
[ ] Static 500.html works without Rails running
[ ] Mobile responsive on real devices
[ ] Accessibility tested with screen reader
[ ] Cross-browser tested
[ ] Performance tested (load times < 2s)
[ ] Error tracking integrated (if using)
[ ] Team reviewed messaging and design
[ ] Staging environment tested
[ ] Rollback plan prepared
```

## Maintenance Plan

### Regular Reviews
- **Quarterly:** Review error page analytics
  - How often are they shown?
  - Which errors are most common?
  - Are users finding their way back?

- **Annually:** Refresh design
  - Update to match any branding changes
  - Improve messaging based on user feedback
  - Add new helpful features

### Monitoring
- Track 404 error rates (sudden spike = broken links)
- Monitor 500 error frequency (spike = critical issue)
- Review user paths after errors

## Success Metrics

How to measure if error pages are effective:

1. **User Recovery Rate**
   - % of users who navigate away from error page successfully
   - Target: > 80% click "Go Home" or other action

2. **Error Frequency**
   - Number of 404s per day (identify broken links)
   - Number of 500s per day (monitor application health)

3. **User Satisfaction**
   - Optional feedback widget on error pages
   - Support ticket mentions of error pages

4. **Time on Error Page**
   - Users should quickly understand and act
   - Long time = confusing page

## Common Pitfalls to Avoid

1. **500 Page Depends on Application**
   - ❌ Don't query database in 500 handler
   - ✅ Keep static fallback that always works

2. **Inconsistent Design**
   - ❌ Error pages look completely different from app
   - ✅ Use same colors, fonts, and style

3. **Unhelpful Messages**
   - ❌ "Error occurred" with no context
   - ✅ Clear explanation and actionable steps

4. **No Testing**
   - ❌ Deploy without testing actual error scenarios
   - ✅ Test with database down, exceptions raised, etc.

5. **Forgetting Mobile**
   - ❌ Only test on desktop
   - ✅ Error pages must work on mobile

6. **Too Complex**
   - ❌ Error pages with heavy JavaScript, animations
   - ✅ Simple, fast-loading pages

## Future Enhancements

Consider adding later:

1. **Search Functionality** on 404 page
2. **Smart Suggestions** based on URL
3. **Multilingual Support** if app is international
4. **Dark Mode** if app supports it
5. **Maintenance Mode Page** (503)
6. **Custom 403 Forbidden** page
7. **Animation/Illustrations** for delight
8. **A/B Testing** different messaging

## Conclusion

A well-designed error page system:
- Maintains user trust during failures
- Provides clear paths forward
- Reduces support burden
- Shows professionalism
- Improves overall user experience

**Remember:** Error pages are part of your user experience. They might be the difference between a user giving up or giving your app another chance.
