import { initializeApp } from "firebase-admin/app";
import {
  FieldValue,
  GeoPoint,
  Timestamp,
  getFirestore,
} from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import {
  haversineDistanceMeters,
  isInsideRadius,
  isInsideTimeWindow,
  isValidCoordinate,
  type LatLng,
} from "./checkInValidation.js";

initializeApp();

const db = getFirestore();

type CheckInPayload = {
  campaignId: string;
  eventId: string;
  latitude: number;
  longitude: number;
  accuracy?: number;
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

function readPayload(data: unknown): CheckInPayload {
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

export const validateEventCheckIn = onCall(
  {
    region: "asia-southeast1",
    enforceAppCheck: process.env.ENFORCE_APP_CHECK === "true",
  },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Sign in before check-in.");
    }

    const payload = readPayload(request.data);
    const userLocation: LatLng = {
      latitude: payload.latitude,
      longitude: payload.longitude,
    };

    if (!isValidCoordinate(userLocation)) {
      throw new HttpsError("invalid-argument", "User location is invalid.");
    }

    if (payload.accuracy !== undefined && payload.accuracy > 100) {
      throw new HttpsError(
        "failed-precondition",
        "Location accuracy is too low for check-in.",
      );
    }

    const campaignRef = db.collection("campaigns").doc(payload.campaignId);
    const eventRef = campaignRef.collection("events").doc(payload.eventId);
    const participantRef = campaignRef.collection("participants").doc(uid);
    const checkInRef = eventRef.collection("checkins").doc(uid);

    return db.runTransaction(async (transaction) => {
      const [
        campaignSnapshot,
        eventSnapshot,
        participantSnapshot,
        checkInSnapshot,
      ] = await Promise.all([
        transaction.get(campaignRef),
        transaction.get(eventRef),
        transaction.get(participantRef),
        transaction.get(checkInRef),
      ]);

      if (!campaignSnapshot.exists) {
        throw new HttpsError("not-found", "Campaign not found.");
      }

      if (!eventSnapshot.exists) {
        throw new HttpsError("not-found", "Event not found.");
      }

      if (!participantSnapshot.exists) {
        throw new HttpsError("permission-denied", "Join this campaign first.");
      }

      if (checkInSnapshot.exists) {
        throw new HttpsError("already-exists", "This event is already checked in.");
      }

      const campaign = campaignSnapshot.data() ?? {};
      const event = eventSnapshot.data() ?? {};
      const participant = participantSnapshot.data() ?? {};

      if (!["published", "ongoing"].includes(assertString(campaign.status, "campaign.status"))) {
        throw new HttpsError("failed-precondition", "Campaign is not open.");
      }

      if (!["published", "ongoing"].includes(assertString(event.status, "event.status"))) {
        throw new HttpsError("failed-precondition", "Event is not open.");
      }

      if (participant.status !== "approved") {
        throw new HttpsError("permission-denied", "Participant is not approved.");
      }

      if (!["participant", "staff", "organizer", "owner"].includes(String(participant.role))) {
        throw new HttpsError("permission-denied", "Participant role cannot check in.");
      }

      const nowMillis = Date.now();
      const openAt = assertTimestamp(event.checkInOpenAt, "event.checkInOpenAt");
      const closeAt = assertTimestamp(event.checkInCloseAt, "event.checkInCloseAt");
      if (!isInsideTimeWindow(nowMillis, openAt.toMillis(), closeAt.toMillis())) {
        throw new HttpsError("failed-precondition", "Check-in window is closed.");
      }

      const schoolId = assertString(campaign.schoolId, "campaign.schoolId");
      const schoolRef = db.collection("managed_schools").doc(schoolId);
      const schoolSnapshot = await transaction.get(schoolRef);
      if (!schoolSnapshot.exists) {
        throw new HttpsError("failed-precondition", "Managed school not found.");
      }

      const school = schoolSnapshot.data() ?? {};
      if (school.status !== "active") {
        throw new HttpsError("failed-precondition", "Managed school is inactive.");
      }

      const schoolLocation: LatLng = {
        latitude: assertNumber(school.latitude, "school.latitude"),
        longitude: assertNumber(school.longitude, "school.longitude"),
      };

      const radiusMeters =
        typeof event.checkInRadiusMeters === "number"
          ? event.checkInRadiusMeters
          : assertNumber(school.checkInRadiusMeters, "school.checkInRadiusMeters");

      const distanceMeters = haversineDistanceMeters(userLocation, schoolLocation);
      if (!isInsideRadius(userLocation, schoolLocation, radiusMeters)) {
        throw new HttpsError("failed-precondition", "User is outside check-in radius.");
      }

      const serverNow = FieldValue.serverTimestamp();
      transaction.set(checkInRef, {
        uid,
        campaignId: payload.campaignId,
        eventId: payload.eventId,
        schoolId,
        checkedInAt: serverNow,
        location: new GeoPoint(payload.latitude, payload.longitude),
        accuracy: payload.accuracy ?? null,
        distanceMeters,
        source: "callable_validateEventCheckIn",
        createdAt: serverNow,
      });

      transaction.update(participantRef, {
        lastCheckInAt: serverNow,
        updatedAt: serverNow,
      });

      return {
        ok: true,
        alreadyCheckedIn: false,
        distanceMeters,
        radiusMeters,
      };
    });
  },
);
