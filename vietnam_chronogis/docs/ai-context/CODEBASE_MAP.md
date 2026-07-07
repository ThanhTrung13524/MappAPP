# Codebase Map

## Startup

- `lib/main.dart`  
  App entry point. Attempts optional Firebase bootstrap, initializes desktop window options, loads SharedPreferences, starts Riverpod `ProviderScope`, and builds `MaterialApp.router`.

- `lib/core/firebase/firebase_bootstrap.dart`  
  Wraps `Firebase.initializeApp()` so missing Firebase client config produces a recoverable `notConfigured` state.

- `lib/core/firebase/firebase_providers.dart`  
  Provides nullable Firebase Auth, Firestore, and Cloud Functions instances.

- `lib/core/theme/theme_provider.dart`  
  Persists and exposes theme mode.

## Routing

- `lib/core/router/app_router.dart`  
  GoRouter configuration for `/seed`, `/auth`, `/login`, `/map`, and `/explorer`.

- `lib/features/auth/presentation/auth_gate_screen.dart`  
  Firebase-aware route gate.

- `lib/features/auth/presentation/login_screen.dart`  
  Login/logout UI and Firebase not-configured state.

## Firebase domain and data

- `lib/core/firebase/firestore_paths.dart`  
  Centralized Firestore paths.

- `lib/features/auth/domain/app_user_profile.dart`  
  User profile, global role, and status model.

- `lib/features/auth/data/auth_repository.dart`  
  Google sign-in, sign-out, auth state, and profile creation.

- `lib/features/managed_schools/domain/managed_school.dart`  
  Campaign managed school model. This is separate from SQLite OSM `schools`.

- `lib/features/managed_schools/data/managed_school_repository.dart`  
  Firestore managed school stream/create logic.

- `lib/features/campaigns/domain/campaign.dart`  
  Campaign model and status enum.

- `lib/features/campaigns/data/campaign_repository.dart`  
  Campaign stream/create logic; creates owner participant on campaign creation.

- `lib/features/campaigns/presentation/campaigns_screen.dart`  
  Campaigns tab UI for managed schools, campaigns, events, participant review, and check-in.

- `lib/features/campaign_events/domain/campaign_event.dart`  
  Event model and status enum.

- `lib/features/campaign_events/data/campaign_event_repository.dart`  
  Event stream/create logic.

- `lib/features/participants/domain/campaign_participant.dart`  
  Participant role/status model and check-in eligibility helper.

- `lib/features/participants/data/participant_repository.dart`  
  Join campaign and participant approval/rejection logic.

- `lib/features/check_in/domain/check_in_models.dart`  
  Client check-in request/result objects.

- `lib/features/check_in/domain/check_in_validator.dart`  
  Dart Haversine, coordinate, radius, and time-window helpers.

- `lib/features/check_in/data/check_in_repository.dart`  
  Geolocation permission/current location and callable Function invocation.

## Firebase backend

- `firebase.json`  
  Firestore/Functions configuration without project id.

- `firestore.rules`  
  Firestore security rules. Direct client writes to check-ins are denied.

- `firestore.indexes.json`  
  Empty index file until real queries require composites.

- `functions/src/index.ts`  
  Callable `validateEventCheckIn` implementation.

- `functions/src/checkInValidation.ts`  
  Pure TypeScript validation helpers used by the Function and tests.

- `functions/src/checkInValidation.test.ts`  
  Node tests for validation helpers.

## Local database

- `lib/core/database/app_database.dart`  
  Drift database root. Schema version remains 3.

- `lib/core/database/tables/administrative_units_table.dart`  
  Administrative unit table.

- `lib/core/database/tables/tourism_places_table.dart`  
  Overpass tourism POI cache.

- `lib/core/database/tables/schools_table.dart`  
  Overpass school POI cache. Not a Campaign managed school schema.

- `lib/core/database/tables/historical_events_table.dart`  
  Local administrative history table, unrelated to Campaign events.

- `lib/core/database/tables/chat_history_table.dart`  
  Local chat message table.

- `lib/core/database/tables/geojson_cache_table.dart`  
  Cached GeoJSON by administrative code.

## Local DAOs and repositories

- `lib/core/database/daos/administrative_unit_dao.dart`
- `lib/core/database/daos/tourism_dao.dart`
- `lib/core/database/daos/school_dao.dart`
- `lib/core/database/daos/chat_dao.dart`
- `lib/core/database/daos/geojson_dao.dart`
- `lib/data/repositories/administrative_unit_repository.dart`
- `lib/data/repositories/tourism_repository.dart`
- `lib/data/repositories/school_repository.dart`
- `lib/data/repositories/chat_repository.dart`

## API clients and services

- `lib/data/api/huggingface_api_client.dart`  
  Administrative dataset API.

- `lib/data/api/overpass_api_client.dart`  
  Tourism and school POI Overpass client.

- `lib/data/api/wikipedia_service.dart`  
  Tourism summaries/thumbnails.

- `lib/data/api/groq_service.dart`  
  Groq chat service. Missing key is represented as unavailable instead of crashing.

- `lib/data/services/osrm_service.dart`  
  Public OSRM routing API.

## Shared providers

- `lib/shared/providers/database_provider.dart`
- `lib/shared/providers/seed_provider.dart`
- `lib/shared/providers/map_provider.dart`
- `lib/shared/providers/tourism_provider.dart`
- `lib/shared/providers/school_provider.dart`
- `lib/shared/providers/chat_provider.dart`
- `lib/shared/providers/routing_provider.dart`
- `lib/shared/providers/timeline_provider.dart`

## Screens

- `lib/features/shell/presentation/seeding_screen.dart`  
  Startup seed screen. Navigates to `/auth` when seeding completes.

- `lib/features/shell/presentation/app_shell.dart`  
  Main shell with Map, Explorer, Schools, AI, and Campaigns tabs.

- `lib/features/map/presentation/map_view_screen.dart`  
  Main map screen. Now focused on composing the map canvas, controls, and selection overlays.

- `lib/features/map/domain/province_geometry.dart`  
  Province geometry and heatmap stats domain objects.

- `lib/features/map/providers/map_geometry_providers.dart`  
  Province geometry loading, heatmap value/stat calculation, polygon generation, and province hit-testing helpers.

- `lib/features/map/presentation/widgets/map_layers.dart`  
  Consumer widgets for tourism markers, school markers, route polyline/endpoints, and tourism empty-state overlay. This keeps several layer-specific `ref.watch` calls out of the main map build method.

- `lib/features/explorer/presentation/explorer_screen.dart`  
  Tourism browsing/filtering.

- `lib/features/schools/presentation/schools_screen.dart`  
  Local OSM school POI screen.

- `lib/features/ai_chat/presentation/ai_insights_screen.dart`  
  AI chat UI with unconfigured-key state.

## Tests

- `test/check_in_validator_test.dart`  
  Dart check-in distance/radius/time-window tests.

- `test/groq_service_test.dart`  
  Verifies missing Groq key does not throw through provider setup.

- `test/overpass_client_test.dart`  
  Overpass client construction smoke test.

- `test/vietnam_geo_validator_test.dart`  
  Vietnam geometry and heatmap value tests.

- `functions/src/checkInValidation.test.ts`  
  TypeScript validation helper tests.
