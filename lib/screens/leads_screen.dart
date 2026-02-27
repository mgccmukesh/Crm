import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../providers/leads_provider.dart';
import '../models/lead.dart';
import 'lead_detail_screen.dart';

class LeadsScreen extends ConsumerStatefulWidget {
  const LeadsScreen({super.key});

  @override
  ConsumerState<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends ConsumerState<LeadsScreen> {
  final _searchController = TextEditingController();
  String? _selectedStatus;
  String? _selectedSource;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(leadsProvider.notifier).fetchLeads());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref.read(leadsProvider.notifier).fetchLeads(
          search: _searchController.text,
          status: _selectedStatus,
          source: _selectedSource,
        );
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadsState = ref.watch(leadsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, phone, city...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: leadsState.isLoading && leadsState.leads.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : leadsState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(leadsState.error!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _search,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : leadsState.leads.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No leads found'),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async => _search(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: leadsState.leads.length,
                              itemBuilder: (context, index) {
                                final lead = leadsState.leads[index];
                                return _LeadCard(
                                  lead: lead,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LeadDetailScreen(leadId: lead.id),
                                      ),
                                    );
                                    if (result == true) _search();
                                  },
                                  onCall: () => _makeCall(lead.phone),
                                  onWhatsApp: () => _openWhatsApp(lead.phone),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Filter Leads',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'new', 'contacted', 'qualified', 'converted', 'lost']
                    .map((s) => DropdownMenuItem(value: s == 'All' ? null : s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSource,
                decoration: const InputDecoration(
                  labelText: 'Source',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'website', 'referral', 'whatsapp', 'mobile_app']
                    .map((s) => DropdownMenuItem(value: s == 'All' ? null : s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedSource = value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  this.setState(() {});
                  Navigator.pop(context);
                  _search();
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  const _LeadCard({
    required this.lead,
    required this.onTap,
    required this.onCall,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  lead.initials,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lead.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (lead.isStarred)
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.phone,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    if (lead.city != null) ..[
                      const SizedBox(height: 4),
                      Text(
                        lead.city!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _StatusBadge(status: lead.status, color: lead.statusColor),
                        if (lead.source != null)
                          _StatusBadge(status: lead.source!, color: lead.sourceColor),
                      ],
                    ),
                    if (lead.lastActivityAt != null) ..[
                      const SizedBox(height: 4),
                      Text(
                        'Last activity: ${_formatDate(lead.lastActivityAt!)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: onCall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.green),
                    onPressed: onWhatsApp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final String color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(int.parse('FF$color', radix: 16)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Color(int.parse('FF$color', radix: 16)).withOpacity(0.3),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(int.parse('FF$color', radix: 16)),
        ),
      ),
    );
  }
}
