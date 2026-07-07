import {
  GeoPoint,
  Timestamp,
} from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import {
  haversineDistanceMeters,
  isInsideRadius,
  isInsideTimeWindow,
  isValidCoordinate,
  type LatLng,
} from "./checkInValidation.js";

export type CheckInPayload = {
  campaignId: string;
  eventId: string;
  latitude: number;
  longitude: number;
  accuracy?: number;
};

export type CheckInDecision = {
  schoolId: string;
  schoolLocation: LatLng;
  radiusMeters: number;
  distanceMeters: number;
};

export type CheckInContext = {
  payload: CheckInPayload;
  campaign: Record<string, unknown>;
  event: Record<string, unknown>;
  participant: Record<string, unknown>;
  school: Record<string, unknown>;
  checkInExists: boolean;
  nowMillis: number;
};

function readString(data: Record<string, unknown>, key: string): string {
  const value = data[key];
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new HttpsError("invalid-argument", `${key} is required.`);
  }
  return value.trim();
}

function readNumber(data: Record<string, unknown>, key: string): number {
  const value = data[key];
  if (typeof value !== "number" || !Number.isFinite(value)) {
    throw new HttpsError("invalid-argument", `${key} must be a number.`);
  }
  return value;
}

export function readPayload(data: unknown): CheckInPayload {
  if (data === null || typeof data !== "object" || Array.isArray(data)) {
    throw new HttpsError("invalid-argument", "Check-in payload is invalid.");
  }

  const body = data as Record<string, unknown>;
  const accuracyValue = body.accuracy;

  return {
    campaignId: readString(body, "campaignId"),
    eventId: readString(body, "eventId"),
    latitude: readNumber(body, "latitude"),
    longitude: readNumber(body, "longitude"),
    accuracy:
      typeof accuracyValue === "number" && Number.isFinite(accuracyValue)
        ? accuracyValue
        : undefined,
  };
}

function assertTimestamp(value: unknown, fieldName: string): Timestamp {
  if (!(value instanceof Timestamp)) {
    throw new HttpsError("failed-precondition", `${fieldName} is missing.`);
  }
  return value;
}

function assertNumber(value: unknown, fieldName: string): number {
  if (typeof value !== "number" || !Number.isFinite(value)) {
    throw new HttpsError("failed-precondition", `${fieldName} is missing.`);
  }
  return value;
}

function assertString(value: unknown, fieldName: string): string {
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new HttpsError("failed-precondition", `${fieldName} is missing.`);
  }
  return value;
}

function readLocation(data: Record<string, unknown>, entityName: string): LatLng {
  const location = data.location;
  if (location instanceof GeoPoint) {
    return {
      latitude: location.latitude,
      longitude: location.longitude,
    };
  }

  return {
    latitude: assertNumber(data.latitude, `${entityName}.latitude`),
    longitude: assertNumber(data.longitude, `${entityName}.longitude`),
  };
}

function isManagedSchoolActive(data: Record<string, unknown>): boolean {
  if (typeof data.active === "boolean") return data.active;
  return data.status === "active";
}

export function resolveSchoolId(
  campaign: Record<string, unknown>,
  event: Record<string, unknown>,
): string {
  return typeof event.schoolId === "string" && event.schoolId.trim().length > 0
    ? event.schoolId.trim()
    : assertString(campaign.schoolId, "campaign.schoolId");
}

export function evaluateCheckInContext(
  context: CheckInContext,
): CheckInDecision {
  const userLocation: LatLng = {
    latitude: context.payload.latitude,
    longitude: context.payload.longitude,
  };

  if (!isValidCoordinate(userLocation)) {
    throw new HttpsError("invalid-argument", "User location is invalid.");
  }

  if (context.payload.accuracy !== undefined && context.payload.accuracy > 100) {
    throw new HttpsError(
      "failed-precondition",
      "Location accuracy is too low for check-in.",
    );
  }

  if (context.checkInExists) {
    throw new HttpsError("already-exists", "This event is already checked in.");
  }

  if (!["published", "ongoing"].includes(
    assertString(context.campaign.status, "campaign.status"),
  )) {
    throw new HttpsError("failed-precondition", "Campaign is not open.");
  }

  if (!["published", "ongoing"].includes(
    assertString(context.event.status, "event.status"),
  )) {
    throw new HttpsError("failed-precondition", "Event is not open.");
  }

  if (context.participant.status !== "approved") {
    throw new HttpsError("permission-denied", "Participant is not approved.");
  }

  if (!["participant", "staff", "organizer", "owner"].includes(
    String(context.participant.role),
  )) {
    throw new HttpsError("permission-denied", "Participant role cannot check in.");
  }

  const openAt = assertTimestamp(context.event.checkInOpenAt, "event.checkInOpenAt");
  const closeAt = assertTimestamp(
    context.event.checkInCloseAt,
    "event.checkInCloseAt",
  );
  if (!isInsideTimeWindow(context.nowMillis, openAt.toMillis(), closeAt.toMillis())) {
    throw new HttpsError("failed-precondition", "Check-in window is closed.");
  }

  const schoolId = resolveSchoolId(context.campaign, context.event);

  if (!isManagedSchoolActive(context.school)) {
    throw new HttpsError("failed-precondition", "Managed school is inactive.");
  }

  const schoolLocation = readLocation(context.school, "school");
  const radiusMeters =
    typeof context.event.checkInRadiusMeters === "number"
      ? context.event.checkInRadiusMeters
      : assertNumber(context.school.checkInRadiusMeters, "school.checkInRadiusMeters");

  const distanceMeters = haversineDistanceMeters(userLocation, schoolLocation);
  if (!isInsideRadius(userLocation, schoolLocation, radiusMeters)) {
    throw new HttpsError("failed-precondition", "User is outside check-in radius.");
  }

  return {
    schoolId,
    schoolLocation,
    radiusMeters,
    distanceMeters,
  };
}
