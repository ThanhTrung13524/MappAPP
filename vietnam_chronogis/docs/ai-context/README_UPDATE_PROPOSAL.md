# README Update Proposal

The README was not edited as part of this analysis pass. Suggested updates only:

## Add project reality note

Add near the top:

```markdown
> Current implementation note: this repository currently implements Vietnam ChronoGIS, a Flutter/Riverpod/Drift GIS app. It does not yet implement Firebase Authentication, Cloud Firestore, Campaign/Event management, participant roles, or GPS check-in.
```

## Add correct Firebase status

Add a section:

```markdown
## Firebase status

Firebase is not currently configured in this project. There are no Firebase dependencies, generated Firebase options, Firestore rules, Cloud Functions, or platform Firebase config files.

Implemented persistence is local SQLite through Drift.
```

## Add CI caveat

Add:

```markdown
## CI note

The Flutter project lives in `vietnam_chronogis/`. GitHub Actions and local commands should run Flutter commands from that directory.
```

## Add verification commands

Add:

```bash
cd vietnam_chronogis
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Current audit result on 2026-06-24:

- `flutter pub get`: passed
- `dart format --output=none --set-exit-if-changed .`: failed, 43 files would be formatted
- `flutter analyze`: passed
- `flutter test`: passed

## Add warning for Groq key

Add:

```markdown
The AI tab requires `GROQ_API_KEY` via Dart define. Use an example file such as `dart_defines.example.json`, but do not commit real API keys.
```

