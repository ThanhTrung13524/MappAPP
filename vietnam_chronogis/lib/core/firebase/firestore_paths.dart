class FirestorePaths {
  const FirestorePaths._();

  static const users = 'users';
  static const managedSchools = 'managed_schools';
  static const campaigns = 'campaigns';
  static const events = 'events';
  static const participants = 'participants';
  static const checkins = 'checkins';

  static String user(String uid) => '$users/$uid';
  static String managedSchool(String schoolId) => '$managedSchools/$schoolId';
  static String campaign(String campaignId) => '$campaigns/$campaignId';
  static String campaignEvents(String campaignId) =>
      '${campaign(campaignId)}/$events';
  static String campaignEvent(String campaignId, String eventId) =>
      '${campaignEvents(campaignId)}/$eventId';
  static String campaignParticipants(String campaignId) =>
      '${campaign(campaignId)}/$participants';
  static String campaignParticipant(String campaignId, String uid) =>
      '${campaignParticipants(campaignId)}/$uid';
  static String eventCheckins(String campaignId, String eventId) =>
      '${campaignEvent(campaignId, eventId)}/$checkins';
  static String eventCheckin(String campaignId, String eventId, String uid) =>
      '${eventCheckins(campaignId, eventId)}/$uid';
}
