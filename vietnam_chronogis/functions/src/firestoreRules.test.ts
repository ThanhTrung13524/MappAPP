import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { after, before, beforeEach, describe, test } from "node:test";
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  deleteDoc,
  doc,
  GeoPoint,
  setDoc,
  Timestamp,
  updateDoc,
} from "firebase/firestore";

const projectId = "demo-vietnam-chronogis";
let testEnv: RulesTestEnvironment;

function emulatorHost(): { host: string; port: number } {
  const value = process.env.FIRESTORE_EMULATOR_HOST;
  if (!value) {
    throw new Error(
      "FIRESTORE_EMULATOR_HOST is required. Run npm run test:rules:emulator.",
    );
  }
  const [host, port] = value.split(":");
  return { host, port: Number(port) };
}

function activeUser(uid: string, globalRole = "user"): Record<string, unknown> {
  const now = Timestamp.now();
  return {
    uid,
    displayName: uid,
    email: `${uid}@example.test`,
    photoUrl: null,
    globalRole,
    status: "active",
    createdAt: now,
    updatedAt: now,
  };
}

function schoolData(createdBy: string): Record<string, unknown> {
  const now = Timestamp.now();
  return {
    name: "Managed school",
    address: "Ho Chi Minh City",
    location: new GeoPoint(10.7769, 106.7009),
    checkInRadiusMeters: 120,
    active: true,
    createdBy,
    createdAt: now,
    updatedAt: now,
  };
}

function campaignData(ownerId: string): Record<string, unknown> {
  const now = Timestamp.now();
  return {
    title: "Campaign",
    description: "Campaign description",
    schoolId: "school-1",
    ownerId,
    status: "published",
    startAt: Timestamp.fromMillis(now.toMillis() - 60_000),
    endAt: Timestamp.fromMillis(now.toMillis() + 86_400_000),
    createdAt: now,
    updatedAt: now,
  };
}

function eventData(createdBy: string): Record<string, unknown> {
  const now = Timestamp.now();
  return {
    name: "Event",
    schoolId: "school-1",
    description: "Event description",
    startAt: Timestamp.fromMillis(now.toMillis() - 60_000),
    endAt: Timestamp.fromMillis(now.toMillis() + 7_200_000),
    checkInOpenAt: Timestamp.fromMillis(now.toMillis() - 60_000),
    checkInCloseAt: Timestamp.fromMillis(now.toMillis() + 3_600_000),
    checkInRadiusMeters: 120,
    status: "published",
    createdBy,
    createdAt: now,
    updatedAt: now,
  };
}

async function seed(path: string, data: Record<string, unknown>): Promise<void> {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), path), data);
  });
}

function dbFor(uid: string) {
  return testEnv.authenticatedContext(uid).firestore();
}

before(async () => {
  const { host, port } = emulatorHost();
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      host,
      port,
      rules: readFileSync("../firestore.rules", "utf8"),
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

after(async () => {
  await testEnv.cleanup();
});

describe("user profile rules", () => {
  test("allow users to create and update only their own safe profile fields", async () => {
    const alice = dbFor("alice");
    const bob = dbFor("bob");

    await assertSucceeds(setDoc(doc(alice, "users/alice"), activeUser("alice")));
    await assertFails(
      setDoc(doc(alice, "users/alice-admin"), activeUser("alice-admin", "admin")),
    );
    await assertSucceeds(
      updateDoc(doc(alice, "users/alice"), {
        displayName: "Alice Updated",
        updatedAt: Timestamp.now(),
      }),
    );
    await assertFails(
      updateDoc(doc(alice, "users/alice"), {
        globalRole: "admin",
        updatedAt: Timestamp.now(),
      }),
    );
    await assertFails(
      updateDoc(doc(bob, "users/alice"), {
        displayName: "Mallory",
        updatedAt: Timestamp.now(),
      }),
    );
  });
});

describe("managed school rules", () => {
  test("allow active creators to manage their schools and block other users", async () => {
    await seed("users/alice", activeUser("alice"));
    await seed("users/bob", activeUser("bob"));
    await seed("users/admin", activeUser("admin", "admin"));

    const alice = dbFor("alice");
    const bob = dbFor("bob");
    const admin = dbFor("admin");

    await assertSucceeds(
      setDoc(doc(alice, "managed_schools/school-1"), schoolData("alice")),
    );
    await assertFails(
      updateDoc(doc(bob, "managed_schools/school-1"), {
        address: "Changed by Bob",
        updatedAt: Timestamp.now(),
      }),
    );
    await assertSucceeds(
      updateDoc(doc(alice, "managed_schools/school-1"), {
        address: "Changed by Alice",
        updatedAt: Timestamp.now(),
      }),
    );
    await assertFails(deleteDoc(doc(bob, "managed_schools/school-1")));
    await assertSucceeds(deleteDoc(doc(admin, "managed_schools/school-1")));
  });
});

describe("campaign and event rules", () => {
  test("allow an active user to create owned campaign and owner participant bootstrap", async () => {
    await seed("users/alice", activeUser("alice"));

    const alice = dbFor("alice");
    await assertSucceeds(
      setDoc(doc(alice, "campaigns/campaign-owned"), campaignData("alice")),
    );
    await assertSucceeds(
      setDoc(doc(alice, "campaigns/campaign-owned/participants/alice"), {
        userId: "alice",
        role: "owner",
        status: "approved",
        joinedAt: Timestamp.now(),
        approvedAt: Timestamp.now(),
        approvedBy: "alice",
      }),
    );
    await assertFails(
      setDoc(doc(alice, "campaigns/campaign-owned/participants/alice-admin"), {
        userId: "alice-admin",
        role: "owner",
        status: "approved",
        joinedAt: Timestamp.now(),
        approvedAt: Timestamp.now(),
        approvedBy: "alice",
      }),
    );
  });

  test("block unauthorized campaign/event edits and pending organizers", async () => {
    await seed("users/alice", activeUser("alice"));
    await seed("users/bob", activeUser("bob"));
    await seed("users/olivia", activeUser("olivia"));
    await seed("campaigns/campaign-1", campaignData("alice"));
    await seed("campaigns/campaign-1/participants/olivia", {
      userId: "olivia",
      role: "organizer",
      status: "pending",
      joinedAt: Timestamp.now(),
      approvedAt: null,
      approvedBy: null,
    });

    const alice = dbFor("alice");
    const bob = dbFor("bob");
    const olivia = dbFor("olivia");

    await assertFails(
      updateDoc(doc(bob, "campaigns/campaign-1"), {
        title: "Bob takeover",
        updatedAt: Timestamp.now(),
      }),
    );
    await assertFails(
      updateDoc(doc(alice, "campaigns/campaign-1"), {
        ownerId: "bob",
        updatedAt: Timestamp.now(),
      }),
    );
    await assertFails(
      setDoc(
        doc(olivia, "campaigns/campaign-1/events/event-pending"),
        eventData("olivia"),
      ),
    );

    await seed("campaigns/campaign-1/participants/olivia", {
      userId: "olivia",
      role: "organizer",
      status: "approved",
      joinedAt: Timestamp.now(),
      approvedAt: Timestamp.now(),
      approvedBy: "alice",
    });

    await assertSucceeds(
      setDoc(
        doc(olivia, "campaigns/campaign-1/events/event-approved"),
        eventData("olivia"),
      ),
    );
    await assertSucceeds(
      setDoc(doc(alice, "campaigns/campaign-1/events/event-owner"), eventData("alice")),
    );
  });
});

describe("participant rules", () => {
  test("allow self join request and manager approval while blocking self approval and owner role escalation", async () => {
    await seed("users/alice", activeUser("alice"));
    await seed("users/bob", activeUser("bob"));
    await seed("campaigns/campaign-1", campaignData("alice"));

    const alice = dbFor("alice");
    const bob = dbFor("bob");

    await assertSucceeds(
      setDoc(doc(bob, "campaigns/campaign-1/participants/bob"), {
        userId: "bob",
        role: "participant",
        status: "pending",
        joinedAt: Timestamp.now(),
        approvedAt: null,
        approvedBy: null,
      }),
    );
    await assertFails(
      setDoc(doc(bob, "campaigns/campaign-1/participants/alice"), {
        userId: "alice",
        role: "participant",
        status: "pending",
        joinedAt: Timestamp.now(),
        approvedAt: null,
        approvedBy: null,
      }),
    );
    await assertFails(
      updateDoc(doc(bob, "campaigns/campaign-1/participants/bob"), {
        status: "approved",
        role: "organizer",
        approvedAt: Timestamp.now(),
        approvedBy: "bob",
      }),
    );
    await assertFails(
      updateDoc(doc(alice, "campaigns/campaign-1/participants/bob"), {
        status: "approved",
        role: "owner",
        approvedAt: Timestamp.now(),
        approvedBy: "alice",
      }),
    );
    await assertSucceeds(
      updateDoc(doc(alice, "campaigns/campaign-1/participants/bob"), {
        status: "approved",
        role: "participant",
        approvedAt: Timestamp.now(),
        approvedBy: "alice",
      }),
    );
  });
});

describe("check-in rules", () => {
  test("deny all direct client check-in writes", async () => {
    await seed("users/alice", activeUser("alice"));
    await seed("campaigns/campaign-1", campaignData("alice"));
    await seed("campaigns/campaign-1/events/event-1", eventData("alice"));

    const alice = dbFor("alice");
    const path = "campaigns/campaign-1/events/event-1/checkins/alice";

    await assertFails(
      setDoc(doc(alice, path), {
        uid: "alice",
        checkedInAt: Timestamp.now(),
        distanceMeters: 0,
        radiusMeters: 1000,
        approved: true,
      }),
    );

    await seed(path, {
      uid: "alice",
      checkedInAt: Timestamp.now(),
      distanceMeters: 5,
    });

    await assertFails(
      updateDoc(doc(alice, path), {
        checkedInAt: Timestamp.now(),
        distanceMeters: 0,
      }),
    );
    await assertFails(deleteDoc(doc(alice, path)));
  });
});

test("rules test environment is initialized", () => {
  assert.equal(Boolean(testEnv), true);
});
