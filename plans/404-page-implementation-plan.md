# 404 Page Implementation Plan

## Overview
Create a custom 404 (Not Found) error page for the Rails application that matches the application's design system using Tailwind CSS. The page should be user-friendly, provide helpful navigation options, and maintain consistency with the existing application styling.

## Current State Analysis

### Existing Setup
- **Static 404 Page**: The app currently has a basic static HTML file at [`public/404.html`](../public/404.html:1)
  - Plain HTML with inline CSS
  - Generic Rails default styling
  - No integration with Tailwind CSS
  - No navigation or helpful links back to the application

- **Application Design**: 
  - Uses Tailwind CSS v4 (modern @import syntax)
  - Clean, modern design with red accent color (#DC2626 / red-600)
  - Centered layouts with cards and shadows
  - Consistent spacing and typography

- **Layout**: Main application layout at [`app/views/layouts/application.html.erb`](../app/views/layouts/application.html.erb:1)
  - Includes Tailwind and application stylesheets
  - Has proper meta tags and CSRF protection

## Implementation Strategy

### Option 1: Dynamic Rails-Rendered 404 Page (Recommended)

This approach creates a controller and view to render the 404 page, allowing us to:
- Use the application layout and Tailwind CSS
- Add helpful navigation links
- Maintain consistent styling with the rest of the app
- Easily update the page content in the future

#### Components to Create:

1. **ErrorsController** ([`app/controllers/errors_controller.rb`](../app/controllers/errors_controller.rb))
   - Handle 404, 422, and 500 errors
   - Set appropriate HTTP status codes
   - Render custom error views

2. **Error Routes** (Update [`config/routes.rb`](../config/routes.rb:1))
   - Map error status codes to controller actions
   - Use `match` with `via: :all` to catch all HTTP methods

3. **Error Views** (`app/views/errors/`)
   - `not_found.html.erb` (404) - Page not found
   - `unprocessable_entity.html.erb` (422) - Invalid form submission
   - `internal_server_error.html.erb` (500) - Server error

4. **Configuration Updates**
   - Update [`config/application.rb`](../config/application.rb:1) to use custom error pages
   - Update [`config/environments/development.rb`](../config/environments/development.rb) to show custom errors in dev mode (optional, for testing)

### Design Specifications for 404 Page

Based on the existing home page design, the 404 page should include:

**Visual Elements:**
- Large, friendly 404 heading with red accent color
- Clear, helpful message about what happened
- Illustration or icon (could be an emoji like 🔍 or 🗺️)
- Centered layout with vertical centering
- White card/container with subtle shadow
- Background with gray-50 color to match home page

**User Actions:**
- Prominent "Go Home" button (red-600 with hover effect)
- Optional "Search" functionality
- Link to Sidekiq dashboard if user might be looking for it
- Breadcrumb or contextual navigation

**Content Structure:**
```
[Center of page]
├── Icon/Emoji (large)
├── "404" or "Page Not Found" (heading)
├── Helpful message (paragraph)
├── "Go Home" button (primary CTA)
└── Additional links (secondary options)
```

## Implementation Steps

### Step 1: Create ErrorsController
**File**: [`app/controllers/errors_controller.rb`](../app/controllers/errors_controller.rb)

```ruby
class ErrorsController < ApplicationController
  layout 'application'
  
  def not_found
    render status: :not_found
  end
  
  def unprocessable_entity
    render status: :unprocessable_entity
  end
  
  def internal_server_error
    render status: :internal_server_error
  end
end
```

### Step 2: Update Routes
**File**: [`config/routes.rb`](../config/routes.rb:1)

Add error routes:
```ruby
# Error pages
match '/404', to: 'errors#not_found', via: :all
match '/422', to: 'errors#unprocessable_entity', via: :all
match '/500', to: 'errors#internal_server_error', via: :all
```

### Step 3: Create Error Views Directory and 404 View
**File**: `app/views/errors/not_found.html.erb`

Key features:
- Use Tailwind classes matching home page style
- Center vertically and horizontally
- Include clear call-to-action button
- Add helpful messaging
- Use emoji or icon for visual interest

### Step 4: Configure Rails to Use Custom Error Pages
**File**: [`config/application.rb`](../config/application.rb:1)

Add inside the `Application` class:
```ruby
config.exceptions_app = routes
```

This tells Rails to use the routes for error handling instead of static files.

### Step 5: Update Development Environment (Optional)
**File**: `config/environments/development.rb`

To test error pages in development mode:
```ruby
config.consider_all_requests_local = false
```

**Note**: Remember to change this back to `true` when done testing, or development debugging will be harder.

### Step 6: Create Additional Error Pages
**Files**: 
- `app/views/errors/unprocessable_entity.html.erb` (422 error)
- `app/views/errors/internal_server_error.html.erb` (500 error)

These should follow the same design pattern as the 404 page but with appropriate messaging.

## Testing Plan

1. **Manual Testing**:
   - Navigate to `/this-does-not-exist` to trigger 404
   - Verify the page displays correctly
   - Test "Go Home" button functionality
   - Check responsive design on different screen sizes

2. **Route Testing**:
   - Access `/404` directly
   - Access `/422` and `/500` (if implemented)

3. **Integration Testing** (optional):
   - Write controller tests for ErrorsController
   - Test that error pages return correct HTTP status codes
   - Verify layout and styling render correctly

## Benefits of This Approach

1. **Consistency**: Uses the same layout and styling as the rest of the application
2. **Maintainability**: Error pages are regular Rails views, easy to update
3. **User Experience**: Can include helpful navigation and contextual information
4. **Flexibility**: Easy to add dynamic content or tracking in the future
5. **Completeness**: Can handle all error types (404, 422, 500) consistently

## Alternative: Keep Static HTML (Not Recommended)

We could update the existing [`public/404.html`](../public/404.html:1) with Tailwind classes, but this approach has limitations:
- Cannot use application layout
- Cannot include Rails helpers or links
- Requires duplicating styles from the main app
- More difficult to maintain consistency
- Cannot generate Tailwind classes dynamically (would need to precompile)

## Potential Enhancements

After initial implementation, consider:
- Add search functionality on error pages
- Include "Was this helpful?" feedback widget
- Log 404 errors for analytics
- Add suggested pages based on the attempted URL
- Implement custom error tracking (e.g., Sentry, Rollbar)
- Add fun animations or illustrations
- A/B test different messaging

## Questions for Consideration

1. **Should we show the 404 page in development mode?**
   - Pro: Can test the actual user experience
   - Con: Harder to debug routing issues
   - Recommendation: Keep local requests visible by default, but test periodically

2. **Should we create all error pages (422, 500) or just 404?**
   - Recommendation: Create all three for consistency

3. **Should we add tracking/analytics to error pages?**
   - Recommendation: Yes, helps identify broken links and common issues

4. **What tone should the error page have?**
   - Friendly and helpful vs. professional and minimal
   - Recommendation: Friendly tone matching the "Hello, World!" on home page

## Success Criteria

- ✅ Custom 404 page renders with Tailwind styling
- ✅ Page matches the design language of the application
- ✅ Users can easily navigate back to the home page
- ✅ HTTP status codes are correctly set (404)
- ✅ Page is responsive and looks good on mobile
- ✅ Error handling works in all environments
- ✅ Tests verify the functionality

## File Structure After Implementation

```
app/
├── controllers/
│   └── errors_controller.rb          # NEW
├── views/
│   └── errors/
│       ├── not_found.html.erb        # NEW
│       ├── unprocessable_entity.html.erb  # NEW (optional)
│       └── internal_server_error.html.erb # NEW (optional)
config/
├── application.rb                     # UPDATED
├── routes.rb                          # UPDATED
└── environments/
    └── development.rb                 # OPTIONALLY UPDATED (for testing)
```

## Timeline

The implementation should be straightforward and quick:
- Controller and routes setup
- Create 404 view with Tailwind styling
- Configuration changes
- Testing
- Optional: Create 422 and 500 error pages

## Next Steps

Once this plan is approved:
1. Switch to Code mode to implement the changes
2. Create the ErrorsController and routes
3. Build the 404 view with Tailwind styling
4. Update configuration
5. Test the implementation
6. Create additional error pages if desired
7. Run tests and verify everything works
