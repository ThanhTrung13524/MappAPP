import assert from "node:assert/strict";
import test from "node:test";
import { GeoPoint, Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import {
  evaluateCheckInContext,
  readPayload,
  type CheckInContext,
} from "./checkInCore.js";
import { haversineDistanceMeters } from "./checkInValidation.js";

const nowMillis = Date.UTC(2026, 6, 7, 10);
const schoolLocation = { latitude: 10.7769, longitude: 106.7009 };
const userLocation = { latitude: 10.777, longitude: 106.701 };

function timestamp(offsetMinutes: number): Timestamp {
  return Timestamp.fromMillis(nowMillis + offsetMinutes * 60_000);
}

function baseContext(overrides: Partial<CheckInContext> = {}): CheckInContext {
  return {
    payload: {
      campaignId: "campaign-1",
      eventId: "event-1",
      latitude: userLocation.latitude,
      longitude: userLocation.longitude,
      accuracy: 20,
    },
    campaign: {
      schoolId: "campaign-school",
      status: "published",
    },
    event: {
      schoolId: "event-school",
      status: "published",
      checkInOpenAt: timestamp(-15),
      checkInCloseAt: timestamp(60),
    },
    participant: {
      status: "approved",
      role: "participant",
    },
    school: {
      active: true,
      location: new GeoPoint(schoolLocation.latitude, schoolLocation.longitude),
      checkInRadiusMeters: 30,
    },
    checkInExists: false,
    nowMillis,
    ...overrides,
  };
}

function expectHttpsCode(action: () => unknown, code: string): void {
  assert.throws(action, (error) => {
    assert.equal(error instanceof HttpsError, true);
    assert.equal((error as HttpsError).code, code);
    return true;
  });
}

test("accepts an approved participant inside radius", () => {
  const decision = evaluateCheckInContext(baseContext());

  assert.equal(decision.schoolId, "event-school");
  assert.equal(decision.radiusMeters, 30);
  assert.equal(decision.distanceMeters > 10, true);
  assert.equal(decision.distanceMeters < 25, true);
});

test("rejects an approved participant outside radius", () => {
  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          payload: {
            campaignId: "campaign-1",
            eventId: "event-1",
            latitude: 10.8,
            longitude: 106.8,
            accuracy: 20,
          },
        }),
      ),
    "failed-precondition",
  );
});

test("accepts a location exactly on the radius boundary", () => {
  const boundaryRadius = haversineDistanceMeters(userLocation, schoolLocation);

  const decision = evaluateCheckInContext(
    baseContext({
      school: {
        active: true,
        location: new GeoPoint(schoolLocation.latitude, schoolLocation.longitude),
        checkInRadiusMeters: boundaryRadius,
      },
    }),
  );

  assert.equal(decision.distanceMeters <= decision.radiusMeters, true);
});

test("falls back to campaign school when event has no schoolId", () => {
  const decision = evaluateCheckInContext(
    baseContext({
      event: {
        status: "published",
        checkInOpenAt: timestamp(-15),
        checkInCloseAt: timestamp(60),
      },
    }),
  );

  assert.equal(decision.schoolId, "campaign-school");
});

test("rejects pending and rejected participants", () => {
  for (const status of ["pending", "rejected"]) {
    expectHttpsCode(
      () =>
        evaluateCheckInContext(
          baseContext({
            participant: { status, role: "participant" },
          }),
        ),
      "permission-denied",
    );
  }
});

test("rejects an invalid participant role", () => {
  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          participant: { status: "approved", role: "banned" },
        }),
      ),
    "permission-denied",
  );
});

test("rejects inactive campaign and event statuses", () => {
  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          campaign: { schoolId: "campaign-school", status: "cancelled" },
        }),
      ),
    "failed-precondition",
  );

  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          event: {
            schoolId: "event-school",
            status: "cancelled",
            checkInOpenAt: timestamp(-15),
            checkInCloseAt: timestamp(60),
          },
        }),
      ),
    "failed-precondition",
  );
});

test("rejects event windows that are not open or already closed", () => {
  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          event: {
            schoolId: "event-school",
            status: "published",
            checkInOpenAt: timestamp(5),
            checkInCloseAt: timestamp(60),
          },
        }),
      ),
    "failed-precondition",
  );

  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          event: {
            schoolId: "event-school",
            status: "published",
            checkInOpenAt: timestamp(-60),
            checkInCloseAt: timestamp(-5),
          },
        }),
      ),
    "failed-precondition",
  );
});

test("rejects invalid coordinates and low accuracy", () => {
  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          payload: {
            campaignId: "campaign-1",
            eventId: "event-1",
            latitude: 91,
            longitude: 106.701,
            accuracy: 20,
          },
        }),
      ),
    "invalid-argument",
  );

  expectHttpsCode(
    () =>
      evaluateCheckInContext(
        baseContext({
          payload: {
            campaignId: "campaign-1",
            eventId: "event-1",
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
            accuracy: 101,
          },
        }),
      ),
    "failed-precondition",
  );
});

test("rejects duplicate check-in records", () => {
  expectHttpsCode(
    () => evaluateCheckInContext(baseContext({ checkInExists: true })),
    "already-exists",
  );
});

test("ignores fake client role radius distance and timestamp fields", () => {
  const payload = readPayload({
    campaignId: "campaign-1",
    eventId: "event-1",
    latitude: userLocation.latitude,
    longitude: userLocation.longitude,
    accuracy: 20,
    role: "owner",
    radiusMeters: 99_999,
    distanceMeters: 0,
    checkedInAt: "client-time",
  });

  assert.deepEqual(Object.keys(payload).sort(), [
    "accuracy",
    "campaignId",
    "eventId",
    "latitude",
    "longitude",
  ]);

  const decision = evaluateCheckInContext(baseContext({ payload }));
  assert.equal(decision.radiusMeters, 30);
  assert.equal(decision.distanceMeters > 0, true);
});
