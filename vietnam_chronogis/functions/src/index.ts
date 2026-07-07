import { initializeApp } from "firebase-admin/app";
import {
  FieldValue,
  GeoPoint,
  getFirestore,
} from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import {
  evaluateCheckInContext,
  readPayload,
  resolveSchoolId,
} from "./checkInCore.js";

initializeApp();

const db = getFirestore();

const checkInHandler = onCall(
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

      const campaign = campaignSnapshot.data() ?? {};
      const event = eventSnapshot.data() ?? {};
      const participant = participantSnapshot.data() ?? {};

      if (checkInSnapshot.exists) {
        throw new HttpsError("already-exists", "This event is already checked in.");
      }

      const schoolRef = db.collection("managed_schools").doc(
        resolveSchoolId(campaign, event),
      );
      const schoolSnapshot = await transaction.get(schoolRef);
      if (!schoolSnapshot.exists) {
        throw new HttpsError("failed-precondition", "Managed school not found.");
      }

      const school = schoolSnapshot.data() ?? {};
      const decision = evaluateCheckInContext({
        payload,
        campaign,
        event,
        participant,
        school,
        checkInExists: false,
        nowMillis: Date.now(),
      });

      const serverNow = FieldValue.serverTimestamp();
      transaction.set(checkInRef, {
        uid,
        campaignId: payload.campaignId,
        eventId: payload.eventId,
        schoolId: decision.schoolId,
        checkedInAt: serverNow,
        location: new GeoPoint(payload.latitude, payload.longitude),
        accuracy: payload.accuracy ?? null,
        distanceMeters: decision.distanceMeters,
        source: "callable_validateEventCheckIn",
        createdAt: serverNow,
      });

      transaction.update(participantRef, {
        lastCheckInAt: serverNow,
        updatedAt: serverNow,
      });

      return {
        success: true,
        ok: true,
        alreadyCheckedIn: false,
        distanceMeters: decision.distanceMeters,
        radiusMeters: decision.radiusMeters,
        message: "Check-in completed.",
      };
    });
  },
);

export const checkInEvent = checkInHandler;
export const validateEventCheckIn = checkInHandler;
