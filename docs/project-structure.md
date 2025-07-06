# Project Structure

This document outlines the standard project structure for this Flutter starter template. The structure is designed to promote modularity, scalability, testability, and developer productivity by combining a feature-first approach with logical layering for core and data concerns.

```
.
├── lib/                     # Main application source code
│   ├── main.dart
│   │
│   ├── app/                 # App-level configuration and setup
│   │   ├── config/          # Environment settings, flavors
│   │   ├── di/              # Dependency Injection setup
│   │   └── routing/         # Navigation configuration (Router, Routes, Guards)
│   │
│   ├── core/                # Cross-cutting concerns (used ANYWHERE)
│   │   ├── constants/       # Global constants
│   │   ├── error/           # Custom exceptions and failures
│   │   ├── extensions/      # Dart extension methods
│   │   ├── helpers/         # Utility functions/classes
│   │   ├── l10n/            # Localization setup
│   │   ├── network/         # Base network client setup (e.g., Dio)
│   │   ├── theme/           # App theme definitions
│   │   └── widgets/         # Common, reusable UI widgets (AppButton, etc.)
│   │
│   ├── data/                # Data handling layer
│   │   ├── datasources/     # Abstract contracts and concrete impl for data sources (local/remote)
│   │   ├── models/          # Data Transfer Objects (DTOs), Entities
│   │   └── repositories/    # Aggregates data sources, provides data interface
│   │
│   ├── features/            # Feature-specific modules (Vertical Slices)
│   │   ├── auth/            # Example: Authentication Feature
│   │   │   └── presentation/  # UI (Screens, Widgets) & State (Cubit/Bloc)
│   │   └── ...              # Other features (e.g., home, profile, settings)
│   │
│   └── shared/              # Code shared between SOME features, but not core
│       ├── widgets/
│       └── utils/
│
├── test/                    # Unit and Widget Tests
│   ├── core/
│   ├── data/
│   ├── features/
│   └── ...                  # Mirrors lib/ structure
│
├── assets/                  # Static assets (fonts, icons, images, translations)
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   └── translations/
│
├── integration_test/        # End-to-end integration tests
│
├── .vscode/                 # VS Code specific settings (launch.json)
├── analysis_options.yaml    # Linter rules & static analysis
├── build.yaml               # Build runner configurations
├── pubspec.yaml             # Dependencies and project metadata
└── README.md                # Project overview
```

## `lib/` - Application Source Code

This is the heart of the Flutter application.

- **`main_*.dart`**: Entry points for different build environments (development, staging, production). They handle environment-specific setup (e.g., logging levels, API endpoints via `app/config`) and initialize the core application widget (`app/app.dart`).
- **`app/`**: Contains application-level setup and configuration that applies globally.
  - `config/`: Environment variables, flavors, feature flags. Avoid hardcoding environment-specific values elsewhere.
  - `di/`: Dependency Injection setup (e.g., using `get_it`, `Riverpod`, or `provider`). Initializes and provides access to services, repositories, and data sources.
  - `routing/`: Navigation logic using a router package (e.g., `go_router`, `auto_route`). Defines route paths, names, parameters, and guards for access control.
- **`core/`**: Holds truly cross-cutting concerns. Code here should be generic and potentially usable by _any_ part of the application. **Crucially, `core/` should NOT depend on `features/` or `data/` directly.**
  - `constants/`: Application-wide constants (API keys should go in `config`, not here).
  - `error/`: Defines custom application `Exception` classes and potentially a generic `Failure` class for handling errors consistently across layers.
  - `extensions/`: Useful Dart extension methods on core types (`String`, `DateTime`, `BuildContext`, etc.).
  - `helpers/`: General utility functions or classes not specific to any domain (e.g., debouncers, formatters).
  - `l10n/`: Internationalization and localization setup and generated files.
  - `network/`: Base network client configuration (e.g., `Dio` instance setup, interceptors for logging, authentication tokens, error handling).
  - `theme/`: Application theme definition, including colors, typography, and widget themes.
  - `widgets/`: Common, highly reusable UI widgets independent of any specific feature (e.g., `AppButton`, `LoadingIndicator`, `EmptyStateWidget`).
- **`data/`**: Responsible for all data operations and abstraction. **`data/` should NOT depend on `features/`**.
  - `datasources/`: Defines abstract classes (contracts) for data sources (e.g., `AuthRemoteDataSource`, `UserLocalDataSource`). These specify _what_ data operations are possible, not _how_ they are done.
  - `implementations/`: Concrete implementations of the data source contracts. These contain the actual logic using specific libraries (e.g., `FirebaseAuth`, `Dio`, `shared_preferences`, `sqflite`).
  - `models/`: Data Transfer Objects (DTOs) and potentially domain entities. Often implemented using packages like `freezed` for immutability and boilerplate reduction. Subfolders like `request/` and `response/` can organize API-specific models.
  - `repositories/`: Implements repository interfaces (contracts) that provide a clean API for features to interact with data. Repositories orchestrate calls to one or more data sources, handle caching logic, manage data flow, and map data source errors/exceptions to application-level `Failure` objects or throw appropriate exceptions defined in `core/error`. They abstract the data source details from the rest of the app.
- **`features/`**: Contains individual feature modules, structured as vertical slices. Each feature folder should be self-contained as much as possible, only depending on `core/`, `data/`, and potentially `shared/`. **Features should NOT depend directly on other features.** Communication between features happens via navigation/routing or potentially through shared state managed at a higher level (using DI).
  - `feature_name/presentation/`: Contains the UI and state management for the specific feature.
    - `cubit/` (or `bloc/`, `provider/`, `viewmodel/`): State management logic.
    - `screens/` (or `pages/`): Top-level widgets representing distinct screens within the feature.
    - `widgets/`: UI components specific _only_ to this feature.
- **`shared/`**: A pragmatic directory for code that is shared between _multiple_ (but not all) features, but isn't generic enough to belong in `core/`. Use this sparingly to avoid it becoming a dumping ground. Examples: A complex widget used only on the profile and settings features, a utility function specific to handling user-generated content formats used in two different features.

## `test/` - Testing

Contains all unit, widget, and potentially integration tests (though dedicated E2E tests often live in `integration_test/`). The structure within `test/` should mirror the `lib/` directory structure to make tests easy to locate.

## `assets/` - Static Assets

Stores static assets used by the application.

- `fonts/`: Custom font files.
- `icons/`: Custom icon files (SVG, PNG).
- `images/`: Image files used within the app.
- `translations/`: Language files (`.arb`, `.json`) for localization.

## `integration_test/` - Integration Testing

Contains end-to-end tests that drive the application UI, typically using `package:integration_test`.

## Root Directory Files

- `.vscode/launch.json`: VS Code launch configurations for running different flavors easily.
- `analysis_options.yaml`: Configuration for the Dart static analyzer and linter rules (e.g., using `package:lints` or custom rules).
- `build.yaml`: Configuration for code generation via `build_runner` (e.g., for `freezed`, `json_serializable`, `auto_route`).
- `pubspec.yaml`: The Flutter project manifest file, defining dependencies, assets, fonts, etc.
- `README.md`: The main entry point for documentation, providing an overview, setup instructions, and links to further documentation (like this file).

This structure provides a balance between organization, flexibility, and scalability, making it suitable for projects ranging from medium to large complexity. Adhering to these conventions helps maintain consistency and makes onboarding new developers easier.
