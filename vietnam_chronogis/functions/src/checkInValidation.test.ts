import assert from "node:assert/strict";
import test from "node:test";
import {
  haversineDistanceMeters,
  isInsideRadius,
  isInsideTimeWindow,
  isValidCoordinate,
} from "./checkInValidation.js";

test("validates coordinate bounds", () => {
  assert.equal(isValidCoordinate({ latitude: 10.7769, longitude: 106.7009 }), true);
  assert.equal(isValidCoordinate({ latitude: 91, longitude: 106.7009 }), false);
  assert.equal(isValidCoordinate({ latitude: 10.7769, longitude: 181 }), false);
});

test("measures nearby coordinates in meters", () => {
  const distance = haversineDistanceMeters(
    { latitude: 10.7769, longitude: 106.7009 },
    { latitude: 10.777, longitude: 106.701 },
  );

  assert.equal(distance > 10, true);
  assert.equal(distance < 25, true);
});

test("checks radius and time window", () => {
  assert.equal(
    isInsideRadius(
      { latitude: 10.7769, longitude: 106.7009 },
      { latitude: 10.777, longitude: 106.701 },
      30,
    ),
    true,
  );

  assert.equal(isInsideTimeWindow(1000, 999, 1001), true);
  assert.equal(isInsideTimeWindow(1000, 1001, 2000), false);
});
