# Database Schema

## Local SQLite schema

The ChronoGIS data store is local SQLite through Drift. Schema version remains `3`; this task did not change Drift schema or migrations.

Implemented local tables:

- `administrative_units`
- `geojson_caches`
- `tourism_places`
- `schools`
- `historical_events`
- `chat_history_messages`

The local `schools` table is an OpenStreetMap school POI cache. It has no owner, campaign relation, authorization fields, or check-in radius. Do not treat it as a Campaign/Event managed school table.

```mermaid
erDiagram
  ADMINISTRATIVE_UNITS {
    text id PK
    text kind
    text ma
    text ten
    text type
    real centroidLon
    real centroidLat
    text macroRegion
  }

  GEOJSON_CACHES {
    text ma PK
    text geoJsonData
  }

  TOURISM_PLACES {
    int osmId PK
    text name
    text category
    real lat
    real lon
    text provinceMa
  }

  SCHOOLS {
    int osmId PK
    text name
    text schoolType
    real lat
    real lon
    text provinceMa
    text provinceName
  }

  HISTORICAL_EVENTS {
    int id PK
    text title
    text description
    int startYear
    int endYear
  }

  CHAT_HISTORY_MESSAGES {
    text id PK
    text role
    text content
    datetime timestamp
  }
```

## Firestore schema

Firebase Campaign/Event data is stored in Firestore. Collection names are centralized in `lib/core/firebase/firestore_paths.dart`.

```mermaid
erDiagram
  USERS {
    string uid PK
    string email
    string displayName
    string photoUrl
    string globalRole
    string status
    timestamp createdAt
    timestamp updatedAt
  }

  MANAGED_SCHOOLS {
    string id PK
    string name
    string address
    number latitude
    number longitude
    number checkInRadiusMeters
    string status
    string createdBy
    timestamp createdAt
    timestamp updatedAt
  }

  CAMPAIGNS {
    string id PK
    string schoolId
    string ownerId
    string title
    string description
    string status
    timestamp startsAt
    timestamp endsAt
    timestamp createdAt
    timestamp updatedAt
  }

  CAMPAIGN_EVENTS {
    string id PK
    string campaignId
    string title
    string description
    string status
    timestamp startsAt
    timestamp endsAt
    timestamp checkInOpenAt
    timestamp checkInCloseAt
    number checkInRadiusMeters
    timestamp createdAt
    timestamp updatedAt
  }

  PARTICIPANTS {
    string uid PK
    string campaignId
    string role
    string status
    timestamp requestedAt
    timestamp reviewedAt
    string reviewedBy
    timestamp lastCheckInAt
  }

  CHECKINS {
    string uid PK
    string campaignId
    string eventId
    string schoolId
    geopoint location
    number accuracy
    number distanceMeters
    string source
    timestamp checkedInAt
    timestamp createdAt
  }
```

## Firestore paths

| Path | Purpose | Client writes |
| --- | --- | --- |
| `users/{uid}` | Auth profile and global role/status. | Self create/update limited profile fields; role/status not self-editable. |
| `managed_schools/{schoolId}` | Organizer school records with GPS radius. | Admin only by rules. |
| `campaigns/{campaignId}` | Campaign metadata. | Signed-in creator can create draft; managers can update. |
| `campaigns/{campaignId}/events/{eventId}` | Campaign event metadata and check-in window. | Campaign managers only. |
| `campaigns/{campaignId}/participants/{uid}` | Membership, campaign role, approval status. | User can create own pending request; managers review. |
| `campaigns/{campaignId}/events/{eventId}/checkins/{uid}` | Server-validated check-in record. | Direct client writes denied; Cloud Function writes. |

## Cloud Function validation

`functions/src/index.ts` exports callable `validateEventCheckIn`.

Validation performed:

- Firebase Auth user is present.
- Payload campaign/event/location fields are valid.
- Location accuracy is acceptable when provided.
- Campaign and event exist and are `published` or `ongoing`.
- Participant exists, is `approved`, and has an allowed campaign role.
- Current server time is inside the event check-in window.
- Managed school exists and is active.
- User location is within event or school radius.
- Duplicate check-in document does not already exist.

## Security rules status

`firestore.rules` denies direct client writes to check-ins and models basic user/admin/campaign manager authorization. The rules file has not yet been emulator-tested because Firebase CLI could not be fetched in this environment.

## Indexes

`firestore.indexes.json` currently contains no custom composite indexes. Add indexes when Firestore query errors identify required composites from real usage.
