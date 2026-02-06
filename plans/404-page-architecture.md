# 404 Page Architecture

## Request Flow Diagram

```mermaid
graph TD
    A[User requests /non-existent-page] --> B{Route exists?}
    B -->|No| C[Rails raises ActionController::RoutingError]
    C --> D[config.exceptions_app intercepts]
    D --> E[Routes to /404]
    E --> F[ErrorsController#not_found]
    F --> G[Renders app/views/errors/not_found.html.erb]
    G --> H[Uses app/views/layouts/application.html.erb]
    H --> I[Applies Tailwind CSS styling]
    I --> J[Returns 404 status with custom page]
    J --> K[User sees styled 404 page]
```

## Component Architecture

```mermaid
graph LR
    A[public/404.html] -.->|Replaced by| B[Dynamic Error Pages]
    B --> C[ErrorsController]
    C --> D[app/views/errors/]
    D --> E[not_found.html.erb]
    D --> F[unprocessable_entity.html.erb]
    D --> G[internal_server_error.html.erb]
    E --> H[application.html.erb layout]
    F --> H
    G --> H
    H --> I[Tailwind CSS]
```

## Configuration Changes

```mermaid
graph TD
    A[config/application.rb] -->|Sets| B[config.exceptions_app = routes]
    C[config/routes.rb] -->|Defines| D[Error Routes]
    D --> E[match /404 to errors#not_found]
    D --> F[match /422 to errors#unprocessable_entity]
    D --> G[match /500 to errors#internal_server_error]
    B --> H[Error handling uses routes instead of static files]
```

## Error Handling Flow

```mermaid
sequenceDiagram
    participant User
    participant Rails Router
    participant ErrorsController
    participant View
    participant Layout
    
    User->>Rails Router: GET /invalid-url
    Rails Router->>Rails Router: No matching route found
    Rails Router->>ErrorsController: Route to errors#not_found
    ErrorsController->>ErrorsController: Set status to 404
    ErrorsController->>View: Render not_found.html.erb
    View->>Layout: Use application.html.erb
    Layout->>User: Return styled 404 page with status 404
```

## File Dependencies

```mermaid
graph TD
    A[errors_controller.rb] --> B[not_found.html.erb]
    B --> C[application.html.erb]
    C --> D[tailwind.css]
    C --> E[application.css]
    F[config/application.rb] -.->|Configures| A
    G[config/routes.rb] -->|Routes to| A
    H[Rails Exception] -->|Triggers| G
```

## Design System Integration

```mermaid
graph LR
    A[Home Page Design] --> B[Design Tokens]
    B --> C[Red-600 Primary Color]
    B --> D[Gray-50 Background]
    B --> E[Centered Layout]
    B --> F[Card Components]
    B --> G[Tailwind Typography]
    
    H[404 Page] --> C
    H --> D
    H --> E
    H --> F
    H --> G
```

## Key Design Decisions

### 1. Dynamic vs Static
- **Chosen**: Dynamic Rails-rendered pages
- **Rationale**: Allows use of application layout, Tailwind CSS, and Rails helpers

### 2. Controller Approach
- **Chosen**: Dedicated ErrorsController
- **Rationale**: Separates concerns, follows Rails conventions, easy to extend

### 3. Styling Strategy
- **Chosen**: Use application layout with Tailwind
- **Rationale**: Ensures consistency with rest of application, maintainable

### 4. Configuration Method
- **Chosen**: config.exceptions_app = routes
- **Rationale**: Standard Rails approach for custom error pages

## Benefits Summary

1. **Consistency**: Matches application design system
2. **Maintainability**: Uses standard Rails patterns
3. **Flexibility**: Easy to update content and styling
4. **User Experience**: Provides helpful navigation
5. **Extensibility**: Can add analytics, search, etc.

## Testing Strategy

```mermaid
graph TD
    A[Testing] --> B[Manual Testing]
    A --> C[Automated Testing]
    
    B --> D[Navigate to invalid URL]
    B --> E[Check page styling]
    B --> F[Test navigation links]
    B --> G[Verify responsive design]
    
    C --> H[Controller Tests]
    C --> I[Integration Tests]
    C --> J[Status Code Tests]
    
    H --> K[Assert correct template rendered]
    I --> L[Assert layout applied]
    J --> M[Assert 404 status returned]
```
