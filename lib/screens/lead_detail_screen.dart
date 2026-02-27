import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../providers/leads_provider.dart';
import '../models/lead.dart';
import '../models/lead_note.dart';

class LeadDetailScreen extends ConsumerStatefulWidget {
  final int leadId;

  const LeadDetailScreen({super.key, required this.leadId});

  @override
  ConsumerState<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends ConsumerState<LeadDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Lead? _lead;
  bool _isLoading = true;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLead();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadLead() async {
    setState(() => _isLoading = true);
    final lead = await ref.read(leadsProvider.notifier).fetchLeadDetail(widget.leadId);
    setState(() {
      _lead = lead;
      _isLoading = false;
    });
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      // You can add call logging here
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _addNote() async {
    if (_noteController.text.isEmpty) return;

    final success = await ref.read(leadsProvider.notifier).addNote(
          widget.leadId,
          _noteController.text,
        );

    if (success && mounted) {
      _noteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note added successfully')),
      );
      _loadLead();
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final success = await ref.read(leadsProvider.notifier).updateStatus(
          widget.leadId,
          newStatus,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
      _loadLead();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lead Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_lead == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lead Details')),
        body: const Center(child: Text('Lead not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_lead!.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: _updateStatus,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'new', child: Text('New')),
              const PopupMenuItem(value: 'contacted', child: Text('Contacted')),
              const PopupMenuItem(value: 'qualified', child: Text('Qualified')),
              const PopupMenuItem(value: 'converted', child: Text('Converted')),
              const PopupMenuItem(value: 'lost', child: Text('Lost')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    _lead!.initials,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _lead!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(_lead!.phone),
                if (_lead!.email != null) Text(_lead!.email!),
                if (_lead!.city != null) Text(_lead!.city!),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _StatusChip(status: _lead!.status, color: _lead!.statusColor),
                    if (_lead!.source != null)
                      _StatusChip(status: _lead!.source!, color: _lead!.sourceColor),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _makeCall(_lead!.phone),
                      icon: const Icon(Icons.call),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(_lead!.phone),
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Notes'),
              Tab(text: 'Call Logs'),
            ],
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotesTab(),
                _buildCallLogsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _tabController.index == 0
          ? Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          hintText: 'Add a note...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addNote,
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildNotesTab() {
    // Mock notes - in real app, fetch from API
    final notes = _lead!.notes ?? [];

    if (notes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No notes yet'),
            SizedBox(height: 8),
            Text(
              'Add your first note below',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(
                        note.userName[0].toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.userName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy · h:mm a').format(note.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(note.note),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallLogsTab() {
    // Mock call logs - in real app, fetch from API
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.call_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No call logs yet'),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final String color;

  const _StatusChip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(int.parse('FF$color', radix: 16)),
        ),
      ),
      backgroundColor: Color(int.parse('FF$color', radix: 16)).withOpacity(0.1),
      side: BorderSide(
        color: Color(int.parse('FF$color', radix: 16)).withOpacity(0.3),
      ),
    );
  }
}
