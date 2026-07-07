import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../auth/data/auth_repository.dart';
import '../../campaign_events/data/campaign_event_repository.dart';
import '../../campaign_events/domain/campaign_event.dart';
import '../../check_in/data/check_in_repository.dart';
import '../../managed_schools/data/managed_school_repository.dart';
import '../../managed_schools/domain/managed_school.dart';
import '../../participants/data/participant_repository.dart';
import '../../participants/domain/campaign_participant.dart';
import '../data/campaign_repository.dart';
import '../domain/campaign.dart';

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  final _schoolName = TextEditingController();
  final _schoolAddress = TextEditingController();
  final _schoolLat = TextEditingController();
  final _schoolLon = TextEditingController();
  final _schoolRadius = TextEditingController(text: '100');
  final _campaignTitle = TextEditingController();
  final _campaignDescription = TextEditingController();
  String? _selectedSchoolId;

  @override
  void dispose() {
    _schoolName.dispose();
    _schoolAddress.dispose();
    _schoolLat.dispose();
    _schoolLon.dispose();
    _schoolRadius.dispose();
    _campaignTitle.dispose();
    _campaignDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(firebaseBootstrapResultProvider);
    final isConfigured = ref.watch(firebaseConfiguredProvider);
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;
    final schoolsAsync = ref.watch(managedSchoolsProvider);
    final campaignsAsync = ref.watch(campaignsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF12151C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D23),
        title: const Text(
          'Campaigns',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          if (user != null)
            TextButton.icon(
              onPressed: () => ref.read(authActionProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!isConfigured)
            _InfoPanel(
              icon: Icons.warning_amber_outlined,
              color: const Color(0xFFFFB74D),
              title: 'Firebase not configured',
              message: bootstrap.message,
            ),
          if (bootstrap.status == FirebaseBootstrapStatus.failed)
            _InfoPanel(
              icon: Icons.error_outline,
              color: const Color(0xFFE24B4A),
              title: 'Firebase initialization failed',
              message: bootstrap.message,
            ),
          _InfoPanel(
            icon: user == null ? Icons.lock_outline : Icons.verified_user,
            color: user == null
                ? const Color(0xFFFFB74D)
                : const Color(0xFF4CAF50),
            title: user == null ? 'Signed out' : 'Signed in',
            message: user == null
                ? 'Open Login to sign in before creating or joining campaigns.'
                : '${profile?.displayName ?? user.email ?? user.uid} • role=${profile?.globalRole.name ?? 'user'}',
          ),
          _Section(
            title: 'Managed schools',
            child: schoolsAsync.when(
              data: (schools) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ManagedSchoolForm(
                    name: _schoolName,
                    address: _schoolAddress,
                    latitude: _schoolLat,
                    longitude: _schoolLon,
                    radius: _schoolRadius,
                    enabled: isConfigured && user != null,
                  ),
                  const SizedBox(height: 12),
                  if (schools.isEmpty)
                    const Text(
                      'No managed schools yet.',
                      style: TextStyle(color: Colors.white54),
                    )
                  else
                    ...schools.map(_SchoolTile.new),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => _ErrorText(text: error.toString()),
            ),
          ),
          _Section(
            title: 'Create campaign',
            child: schoolsAsync.when(
              data: (schools) {
                if (_selectedSchoolId == null && schools.isNotEmpty) {
                  _selectedSchoolId = schools.first.id;
                }
                return _CampaignForm(
                  title: _campaignTitle,
                  description: _campaignDescription,
                  schools: schools,
                  selectedSchoolId: _selectedSchoolId,
                  enabled: isConfigured && user != null && schools.isNotEmpty,
                  onSchoolChanged: (value) {
                    setState(() => _selectedSchoolId = value);
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => _ErrorText(text: error.toString()),
            ),
          ),
          _Section(
            title: 'Campaign list',
            child: campaignsAsync.when(
              data: (campaigns) {
                if (campaigns.isEmpty) {
                  return const Text(
                    'No campaigns yet.',
                    style: TextStyle(color: Colors.white54),
                  );
                }
                return Column(
                  children: [
                    for (final campaign in campaigns)
                      _CampaignCard(campaign: campaign),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => _ErrorText(text: error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagedSchoolForm extends ConsumerWidget {
  const _ManagedSchoolForm({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.enabled,
  });

  final TextEditingController name;
  final TextEditingController address;
  final TextEditingController latitude;
  final TextEditingController longitude;
  final TextEditingController radius;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(managedSchoolActionProvider);
    return Column(
      children: [
        _TextField(controller: name, label: 'School name', enabled: enabled),
        _TextField(controller: address, label: 'Address', enabled: enabled),
        Row(
          children: [
            Expanded(
              child: _TextField(
                controller: latitude,
                label: 'Latitude',
                enabled: enabled,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TextField(
                controller: longitude,
                label: 'Longitude',
                enabled: enabled,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TextField(
                controller: radius,
                label: 'Radius m',
                enabled: enabled,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        if (action.hasError) _ErrorText(text: action.error.toString()),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: enabled && !action.isLoading
                ? () => ref
                      .read(managedSchoolActionProvider.notifier)
                      .createSchool(
                        name: name.text,
                        address: address.text,
                        latitude: double.tryParse(latitude.text) ?? 0,
                        longitude: double.tryParse(longitude.text) ?? 0,
                        radiusMeters: double.tryParse(radius.text) ?? 0,
                      )
                : null,
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Create school'),
          ),
        ),
      ],
    );
  }
}

class _CampaignForm extends ConsumerWidget {
  const _CampaignForm({
    required this.title,
    required this.description,
    required this.schools,
    required this.selectedSchoolId,
    required this.enabled,
    required this.onSchoolChanged,
  });

  final TextEditingController title;
  final TextEditingController description;
  final List<ManagedSchool> schools;
  final String? selectedSchoolId;
  final bool enabled;
  final ValueChanged<String?> onSchoolChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(campaignActionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TextField(
          controller: title,
          label: 'Campaign title',
          enabled: enabled,
        ),
        _TextField(
          controller: description,
          label: 'Description',
          enabled: enabled,
        ),
        DropdownButtonFormField<String>(
          initialValue: selectedSchoolId,
          dropdownColor: const Color(0xFF1A1D23),
          decoration: _inputDecoration('Managed school'),
          items: [
            for (final school in schools)
              DropdownMenuItem(value: school.id, child: Text(school.name)),
          ],
          onChanged: enabled ? onSchoolChanged : null,
        ),
        if (action.hasError) _ErrorText(text: action.error.toString()),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: enabled && !action.isLoading && selectedSchoolId != null
                ? () {
                    final now = DateTime.now();
                    ref
                        .read(campaignActionProvider.notifier)
                        .createCampaign(
                          title: title.text,
                          description: description.text,
                          schoolId: selectedSchoolId!,
                          startAt: now,
                          endAt: now.add(const Duration(days: 30)),
                        );
                  }
                : null,
            icon: const Icon(Icons.campaign),
            label: const Text('Create campaign'),
          ),
        ),
      ],
    );
  }
}

class _CampaignCard extends ConsumerStatefulWidget {
  const _CampaignCard({required this.campaign});

  final Campaign campaign;

  @override
  ConsumerState<_CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends ConsumerState<_CampaignCard> {
  final _eventName = TextEditingController();
  final _eventDescription = TextEditingController();
  final _eventRadius = TextEditingController();

  @override
  void dispose() {
    _eventName.dispose();
    _eventDescription.dispose();
    _eventRadius.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final participant = ref.watch(
      currentParticipantProvider(widget.campaign.id),
    );
    final participants = ref.watch(participantsProvider(widget.campaign.id));
    final events = ref.watch(campaignEventsProvider(widget.campaign.id));
    final canManage =
        user?.uid == widget.campaign.ownerId ||
        participant.value?.role == CampaignRole.owner ||
        participant.value?.role == CampaignRole.organizer;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.campaign.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.campaign.status.name} • owner ${widget.campaign.ownerId}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          if (widget.campaign.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.campaign.description,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 12),
          _ParticipantActions(
            campaignId: widget.campaign.id,
            participant: participant.value,
            canJoin: user != null,
          ),
          if (canManage)
            _EventForm(
              campaignId: widget.campaign.id,
              name: _eventName,
              description: _eventDescription,
              radius: _eventRadius,
            ),
          const SizedBox(height: 12),
          events.when(
            data: (items) => Column(
              children: [
                for (final event in items)
                  _EventTile(campaign: widget.campaign, event: event),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => _ErrorText(text: error.toString()),
          ),
          if (canManage)
            participants.when(
              data: (items) => _ParticipantsPanel(
                campaignId: widget.campaign.id,
                participants: items,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => _ErrorText(text: error.toString()),
            ),
        ],
      ),
    );
  }
}

class _ParticipantActions extends ConsumerWidget {
  const _ParticipantActions({
    required this.campaignId,
    required this.participant,
    required this.canJoin,
  });

  final String campaignId;
  final CampaignParticipant? participant;
  final bool canJoin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(participantActionProvider);
    final text = participant == null
        ? 'Not joined'
        : '${participant!.status.name} • ${participant!.role.name}';
    return Row(
      children: [
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white70)),
        ),
        TextButton.icon(
          onPressed: canJoin && participant == null && !action.isLoading
              ? () => ref
                    .read(participantActionProvider.notifier)
                    .joinCampaign(campaignId)
              : null,
          icon: const Icon(Icons.person_add),
          label: const Text('Join'),
        ),
      ],
    );
  }
}

class _EventForm extends ConsumerWidget {
  const _EventForm({
    required this.campaignId,
    required this.name,
    required this.description,
    required this.radius,
  });

  final String campaignId;
  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(campaignEventActionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: Colors.white12),
        _TextField(controller: name, label: 'Event name', enabled: true),
        _TextField(
          controller: description,
          label: 'Event description',
          enabled: true,
        ),
        _TextField(
          controller: radius,
          label: 'Override radius meters (optional)',
          enabled: true,
          keyboardType: TextInputType.number,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: action.isLoading
                ? null
                : () {
                    final now = DateTime.now();
                    ref
                        .read(campaignEventActionProvider.notifier)
                        .createEvent(
                          campaignId: campaignId,
                          name: name.text,
                          description: description.text,
                          startAt: now,
                          endAt: now.add(const Duration(hours: 2)),
                          checkInOpenAt: now.subtract(
                            const Duration(minutes: 15),
                          ),
                          checkInCloseAt: now.add(const Duration(hours: 2)),
                          radiusMeters: double.tryParse(radius.text),
                        );
                  },
            icon: const Icon(Icons.event),
            label: const Text('Create event'),
          ),
        ),
      ],
    );
  }
}

class _EventTile extends ConsumerWidget {
  const _EventTile({required this.campaign, required this.event});

  final Campaign campaign;
  final CampaignEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkIn = ref.watch(checkInActionProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event_available, color: Color(0xFF4A90E2)),
      title: Text(event.name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        'Check-in ${event.checkInOpenAt} -> ${event.checkInCloseAt}',
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: TextButton.icon(
        onPressed: checkIn.isLoading
            ? null
            : () => ref
                  .read(checkInActionProvider.notifier)
                  .checkIn(campaignId: campaign.id, eventId: event.id),
        icon: const Icon(Icons.my_location),
        label: const Text('Check-in'),
      ),
    );
  }
}

class _ParticipantsPanel extends ConsumerWidget {
  const _ParticipantsPanel({
    required this.campaignId,
    required this.participants,
  });

  final String campaignId;
  final List<CampaignParticipant> participants;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (participants.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: Colors.white12),
        const Text(
          'Participants',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        for (final participant in participants)
          Row(
            children: [
              Expanded(
                child: Text(
                  '${participant.userId} • ${participant.status.name} • ${participant.role.name}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () => ref
                    .read(participantActionProvider.notifier)
                    .approve(
                      campaignId: campaignId,
                      userId: participant.userId,
                    ),
                child: const Text('Approve'),
              ),
              TextButton(
                onPressed: () => ref
                    .read(participantActionProvider.notifier)
                    .reject(campaignId: campaignId, userId: participant.userId),
                child: const Text('Reject'),
              ),
            ],
          ),
      ],
    );
  }
}

class _SchoolTile extends StatelessWidget {
  const _SchoolTile(this.school);

  final ManagedSchool school;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.location_city, color: Color(0xFF4CAF50)),
      title: Text(school.name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '${school.latitude}, ${school.longitude} • ${school.checkInRadiusMeters.toStringAsFixed(0)}m',
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF171A21),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    required this.enabled,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white54),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF4A90E2)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
    ),
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: const TextStyle(color: Color(0xFFE24B4A))),
    );
  }
}
