import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart';
import '../core/constants/api_constants.dart';
import '../models/lead.dart';
import '../models/lead_note.dart';
import 'auth_provider.dart';

final leadsProvider = StateNotifierProvider<LeadsNotifier, LeadsState>((ref) {
  return LeadsNotifier(ref.read(apiServiceProvider));
});

class LeadsState {
  final List<Lead> leads;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  LeadsState({
    this.leads = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  LeadsState copyWith({
    List<Lead>? leads,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return LeadsState(
      leads: leads ?? this.leads,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class LeadsNotifier extends StateNotifier<LeadsState> {
  final ApiService _apiService;

  LeadsNotifier(this._apiService) : super(LeadsState());

  Future<void> fetchLeads({String? search, String? status, String? source}) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final queryParams = <String, dynamic>{
        'page': 1,
      };
      
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (source != null && source.isNotEmpty) queryParams['source'] = source;

      final response = await _apiService.get(
        ApiConstants.leads,
        queryParameters: queryParams,
      );

      if (response.data['success']) {
        final data = response.data['data'];
        final List<Lead> leads = (data['data'] as List)
            .map((json) => Lead.fromJson(json))
            .toList();
        
        state = state.copyWith(
          leads: leads,
          isLoading: false,
          currentPage: data['current_page'] ?? 1,
          hasMore: data['current_page'] < (data['last_page'] ?? 1),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Lead?> fetchLeadDetail(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.leadDetail(id));
      if (response.data['success']) {
        return Lead.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Error fetching lead detail: $e');
    }
    return null;
  }

  Future<bool> addNote(int leadId, String note) async {
    try {
      final response = await _apiService.post(
        ApiConstants.leadNotes(leadId),
        data: {'note': note},
      );
      return response.data['success'] ?? false;
    } catch (e) {
      print('Error adding note: $e');
      return false;
    }
  }

  Future<bool> updateStatus(int leadId, String status) async {
    try {
      final response = await _apiService.post(
        ApiConstants.leadStatus(leadId),
        data: {'status': status},
      );
      
      if (response.data['success']) {
        // Update local state
        final updatedLeads = state.leads.map((lead) {
          if (lead.id == leadId) {
            return Lead(
              id: lead.id,
              uuid: lead.uuid,
              name: lead.name,
              phone: lead.phone,
              email: lead.email,
              city: lead.city,
              status: status,
              source: lead.source,
              isStarred: lead.isStarred,
              lastActivityAt: DateTime.now(),
              createdAt: lead.createdAt,
            );
          }
          return lead;
        }).toList();
        
        state = state.copyWith(leads: updatedLeads);
        return true;
      }
    } catch (e) {
      print('Error updating status: $e');
    }
    return false;
  }
}
