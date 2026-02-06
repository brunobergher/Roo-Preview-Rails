# 500 Internal Server Error Page Implementation Plan

## Overview
Create a custom 500 (Internal Server Error) page that provides a better user experience when the application encounters unexpected errors. This page has special considerations compared to the 404 page since it's triggered when the application itself is malfunctioning.

## Current State Analysis

### Existing 500 Error Page
- **Location**: [`public/500.html`](../public/500.html:1)
- **Type**: Static HTML with inline CSS
- **Content**: Generic "We're sorry, but something went wrong" message
- **Limitations**: 
  - No branding or styling consistency
  - No helpful actions for users
  - Cannot leverage Rails views (since app may be broken)
  - No visual design elements

### When 500 Errors Occur

500 errors happen when the Rails application encounters an exception it cannot handle:
- Database connection failures
- Unhandled exceptions in controllers/models
- Memory issues or timeouts
- Missing required environment variables
- Redis/Sidekiq connection problems
- Critical configuration errors

**Important**: When a 500 error occurs, the Rails application may not be fully functional, which affects our implementation strategy.

## Critical Design Considerations for 500 Pages

### 1. Fail-Safe Requirement
Unlike 404 errors, 500 errors mean the app is broken. The error page must:
- ✅ Work even if the database is down
- ✅ Work even if Redis is unavailable
- ✅ Work even if Rails routing is broken
- ✅ Not require any application code to execute
- ✅ Load quickly without external dependencies

### 2. Two-Tier Approach (Recommended)

**Tier 1: Static Fallback** (Critical)
- Keep an enhanced [`public/500.html`](../public/500.html:1) as ultimate fallback
- Uses inline CSS or embedded Tailwind CDN
- Zero dependencies on application functionality
- Always works, even in catastrophic failures

**Tier 2: Dynamic Enhanced Page** (When Possible)
- If the Rails app is partially functional, try to render a better page
- Use ErrorsController like the 404 page
- Can log errors, show support info, etc.
- Falls back to static page if this fails

## Implementation Strategy

### Option 1: Enhanced Static HTML Only (Safest)

Update [`public/500.html`](../public/500.html:1) with better styling and messaging, but keep it static.

**Pros:**
- Always works, even in complete failures
- No risk of cascading errors
- Fast to implement
- Most reliable

**Cons:**
- Cannot use Rails layouts or helpers
- Must duplicate styles
- Cannot include dynamic content
- Cannot track errors automatically

### Option 2: Hybrid Approach (Recommended)

Create both a static fallback AND a dynamic page:

1. **Enhanced Static Page** (`public/500.html`)
   - Beautiful, branded design using Tailwind CDN
   - Clear, empathetic messaging
   - Basic actions (refresh, go home)
   - Always available as fallback

2. **Dynamic Page** (`app/views/errors/internal_server_error.html.erb`)
   - Rendered by ErrorsController when Rails is working
   - Can include error tracking
   - Can show more contextual information
   - Uses application layout and styles

**Configuration:**
```ruby
# config/application.rb
config.exceptions_app = routes

# This allows Rails to try the dynamic page first
# If Rails is broken, it falls back to public/500.html automatically
```

### Option 3: Dynamic Only (Not Recommended)

Only use ErrorsController without static fallback.

**Risk:** If the error that triggers the 500 also breaks the controller, users see a blank page or browser error.

## Recommended: Hybrid Implementation

### Component 1: Enhanced Static 500.html

**File**: [`public/500.html`](../public/500.html:1)

**Key Features:**
- Use Tailwind CSS via CDN (no build process needed)
- Match application branding and colors
- Clear, empathetic error message
- Helpful actions without requiring Rails
- Error reference ID (if possible via meta tags)
- Support contact information

**Design Specifications:**

```
[Center of page]
├── Icon/Emoji (⚠️ or 🔧)
├── "500" or "Something Went Wrong" (heading in red-600)
├── Empathetic explanation (paragraph)
├── "Try Again" button (reload page)
├── "Go Home" button (navigate to /)
├── "Contact Support" link
└── Error reference (if available)
```

**Sample Structure:**
```html
<!DOCTYPE html>
<html>
<head>
  <title>Server Error (500)</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            'brand-red': '#DC2626'
          }
        }
      }
    }
  </script>
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center p-8">
  <!-- Error content with Tailwind classes -->
</body>
</html>
```

### Component 2: Dynamic 500 Page (Optional Enhancement)

**File**: `app/views/errors/internal_server_error.html.erb`

This page is rendered when Rails is still functional enough to handle the request.

**Additional Features Over Static:**
- Can log the error details
- Can show more contextual help
- Can use application layout (if safe)
- Can include support ticket creation
- Can track error occurrences

**Safe Controller Implementation:**
```ruby
# app/controllers/errors_controller.rb
class ErrorsController < ApplicationController
  # Don't require authentication or any callbacks that might fail
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user, if: -> { respond_to?(:authenticate_user) }
  
  layout 'application'
  
  def internal_server_error
    # Be careful - if this action has errors, Rails falls back to public/500.html
    
    # Optionally log the error (safely)
    begin
      Rails.logger.error("500 error page accessed at #{Time.current}")
    rescue
      # If logging fails, don't crash the error page
    end
    
    render status: :internal_server_error
  rescue => e
    # If anything fails, let Rails serve public/500.html
    raise
  end
end
```

### Component 3: Routes Configuration

**File**: [`config/routes.rb`](../config/routes.rb:1)

```ruby
# Add to existing routes
match '/500', to: 'errors#internal_server_error', via: :all
```

### Component 4: Application Configuration

**File**: [`config/application.rb`](../config/application.rb:1)

```ruby
# Inside the Application class
config.exceptions_app = routes

# This tells Rails to route errors through the routing system
# If the routing fails, Rails automatically falls back to public/500.html
```

## Special Considerations for 500 Errors

### 1. Database Access
❌ **Don't** query the database in error pages
- The error might BE a database failure
- Querying could cause cascading errors

### 2. External Services
❌ **Don't** call external APIs
- They might be the cause of the error
- Could timeout and make things worse

### 3. Complex Logic
❌ **Don't** use complex application logic
- Keep the error controller extremely simple
- Assume everything might be broken

### 4. Asset Pipeline
⚠️ **Be Careful** with asset dependencies
- If assets fail to compile, error page won't work
- Static page with CDN CSS is safer

### 5. Error Logging
✅ **Do** log errors, but safely
- Wrap in begin/rescue blocks
- Don't let logging failures crash the error page

## Design Specifications

### Visual Design

**Color Scheme:**
- Background: `bg-gray-50` (matches home page)
- Primary: `red-600` for headings and warnings
- Text: `text-gray-800` for body, `text-gray-500` for secondary
- Buttons: Same style as home page

**Layout:**
- Centered vertically and horizontally
- White card with shadow (if using Tailwind)
- Responsive design (mobile-first)

**Typography:**
- Large heading (text-5xl) with emoji
- Clear body text explaining the issue
- Prominent call-to-action buttons

### Content Strategy

**Tone:**
- Empathetic and apologetic
- Reassuring ("we're working on it")
- Clear about what the user can do
- Professional but friendly

**Messaging Examples:**

**Heading Options:**
- "Oops! Something Went Wrong"
- "We're Having Technical Difficulties"
- "Server Error"
- "Something Broke on Our End"

**Body Text:**
- "We're sorry for the inconvenience. Our team has been notified and we're working to fix the issue."
- "This is a problem on our end, not yours. Please try again in a few moments."
- "The server encountered an unexpected error. We've been notified and are investigating."

**User Actions:**
1. **Try Again** (refresh the page)
   - Most problems are temporary
   - Page might work on retry

2. **Go Home** (navigate to /)
   - Safe fallback
   - Might work even if other pages don't

3. **Contact Support** (optional)
   - For persistent issues
   - Provide error reference if possible

### Error Reference System (Optional)

If possible, include a unique error ID:
- Helps support team find logs
- Makes user feel heard
- Shows professionalism

Example: "Error Reference: ERR-2026-02-06-ABC123"

## Implementation Steps

### Step 1: Update Static 500.html
1. Add Tailwind CSS via CDN
2. Create branded design matching app style
3. Add clear messaging and actions
4. Test that it loads without any dependencies

### Step 2: Create Dynamic Error Page (Optional)
1. Update ErrorsController with safe 500 handler
2. Create `app/views/errors/internal_server_error.html.erb`
3. Use application layout (with fallback)
4. Keep logic minimal and safe

### Step 3: Configure Routes and Application
1. Add `/500` route in [`config/routes.rb`](../config/routes.rb:1)
2. Set `config.exceptions_app = routes` in [`config/application.rb`](../config/application.rb:1)
3. Test fallback behavior

### Step 4: Test Error Scenarios
1. Test with database down
2. Test with Redis down
3. Test with intentional exception
4. Verify fallback to static page works

## Testing Strategy

### Manual Testing

**Test 1: Intentional Exception**
```ruby
# Add temporary test route
get '/test_500', to: -> (env) { raise "Test error" }
```

**Test 2: Database Failure Simulation**
- Stop PostgreSQL
- Try to load a page that queries the database
- Verify 500 page displays correctly

**Test 3: Complete Application Failure**
- Introduce syntax error in critical file
- Verify static `public/500.html` still loads

**Test 4: Asset Failure**
- Temporarily break asset pipeline
- Verify error page works without compiled assets

### Automated Testing (Limited)

Due to the nature of 500 errors, automated testing is challenging:

```ruby
# test/controllers/errors_controller_test.rb
class ErrorsControllerTest < ActionController::TestCase
  test "should show internal server error page" do
    get :internal_server_error
    assert_response :internal_server_error
    assert_select 'h1', /server error|went wrong/i
  end
end
```

**Note:** This only tests when Rails is functional. True 500 error scenarios are hard to automate.

## Error Monitoring Integration (Optional)

### Consider Adding

1. **Error Tracking Service** (Sentry, Rollbar, Honeybadger)
   - Automatic error reporting
   - Stack trace capture
   - User impact tracking

2. **Custom Error Logging**
   ```ruby
   # In ErrorsController
   def internal_server_error
     ErrorTrackingService.log_500_page_view
     render status: 500
   rescue
     # Don't let logging break the page
   end
   ```

3. **Metrics/Analytics**
   - Track 500 error frequency
   - Monitor which pages fail most
   - Alert team on spike in errors

## Comparison: 404 vs 500 Pages

| Aspect | 404 Page | 500 Page |
|--------|----------|----------|
| **Cause** | User requested non-existent resource | Application error |
| **App State** | Application is working fine | Application might be broken |
| **Safety** | Can use full Rails features | Must be extremely cautious |
| **User Feeling** | "I made a mistake" | "Something is broken" |
| **Urgency** | Low - user can navigate away | High - needs immediate fix |
| **Complexity** | Can be complex and helpful | Should be simple and reliable |
| **Testing** | Easy to test | Hard to test realistically |
| **Fallback** | Not critical | Critical (must have static fallback) |

## Success Criteria

- ✅ Static 500 page looks professional and branded
- ✅ Static page works without any application dependencies
- ✅ Static page loads quickly (< 1 second)
- ✅ Error message is empathetic and clear
- ✅ Users have clear actions (refresh, go home)
- ✅ Page is responsive and works on mobile
- ✅ Dynamic page works when Rails is functional
- ✅ Fallback to static page works when Rails is broken
- ✅ Errors are logged (when possible)
- ✅ No cascading errors from the error page itself

## Implementation Timeline

**Phase 1: Static Page** (Safest, Immediate Value)
- Update `public/500.html` with Tailwind CDN
- Add proper branding and messaging
- Test without running Rails

**Phase 2: Dynamic Page** (Optional Enhancement)
- Create ErrorsController action
- Create view template
- Add error logging
- Test fallback behavior

**Phase 3: Monitoring** (Future Enhancement)
- Integrate error tracking service
- Add analytics
- Create alerting rules

## Risks and Mitigations

### Risk 1: Error Page Causes More Errors
**Mitigation:** Keep static fallback simple and dependency-free

### Risk 2: CDN Not Available
**Mitigation:** Include critical inline styles as fallback

### Risk 3: Error Page Looks Different from App
**Mitigation:** Match colors and fonts carefully, test side-by-side

### Risk 4: Users Don't Know What to Do
**Mitigation:** Provide clear, actionable steps

### Risk 5: Too Many 500 Errors
**Mitigation:** Implement error monitoring and alerting

## Related Error Pages

This 500 page should be part of a complete error page system:

1. **404 Not Found** - User requested non-existent page
2. **422 Unprocessable Entity** - Form validation failed
3. **500 Internal Server Error** - Application broke (this page)
4. **503 Service Unavailable** - Maintenance mode (optional)

All should share consistent:
- Visual design and branding
- Tone and messaging style
- Navigation patterns
- Responsive behavior

## Next Steps

Once this plan is approved:
1. Choose implementation approach (static only vs. hybrid)
2. Switch to Code mode for implementation
3. Update `public/500.html` with branded design
4. Optionally create dynamic error page
5. Configure Rails error handling
6. Test various failure scenarios
7. Deploy and monitor

## Questions to Consider

1. **Do we want error tracking/monitoring?**
   - Sentry, Rollbar, or similar service?
   - Custom logging solution?

2. **Should we include contact information?**
   - Support email or link?
   - Phone number for critical issues?

3. **Do we want to show the error in development?**
   - Keep detailed error pages in dev?
   - Or show custom pages for consistency?

4. **Should we have a maintenance mode page (503)?**
   - For planned downtime?
   - Different from 500 errors?

5. **What's our error notification strategy?**
   - Email alerts on 500 errors?
   - Slack notifications?
   - PagerDuty for critical issues?
