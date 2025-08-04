import 'package:eventsolutions/model/events/ticket_features_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'dart:developer';

class ScannedDataPage extends ConsumerStatefulWidget {
  const ScannedDataPage({super.key, required this.ticketId});
  final String ticketId;

  @override
  ConsumerState<ScannedDataPage> createState() => _ScannedDataPageState();
}

class _ScannedDataPageState extends ConsumerState<ScannedDataPage> {
  Map<String, bool> featureStatus = {};
  bool isSubmitting = false;
  bool isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Pre-warm the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ticketfeaturesProvider(widget.ticketId));
    });
  }

  // Handle back navigation properly
  Future<bool> _onWillPop() async {
    if (isSubmitting) {
      // Show a dialog if user tries to go back while submitting
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Processing'),
          content: const Text(
              'Feature redemption is in progress. Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        ),
      );
      if (shouldExit != true) return false;
    }

    // Clean up and allow navigation
    _cleanupAndExit();
    return true;
  }

  void _cleanupAndExit() {
    // Clear provider cache
    ref.invalidate(ticketfeaturesProvider(widget.ticketId));

    // Clear local state
    setState(() {
      featureStatus.clear();
      isSubmitting = false;
      isInitialLoad = true;
    });
  }

  Future<void> _exitPage() async {
    _cleanupAndExit();

    // Use pop instead of pushReplacement to maintain proper navigation stack
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _submitChanges(
      List<TicketFeaturesModel> originalFeatures) async {
    if (isSubmitting || !mounted) return;

    try {
      setState(() {
        isSubmitting = true;
      });

      final featuresToRedeem = featureStatus.entries
          .where((entry) {
            final originalFeature = originalFeatures.firstWhere(
              (f) => f.name == entry.key,
              orElse: () => TicketFeaturesModel(name: entry.key, status: false),
            );
            return entry.value == true && !originalFeature.status;
          })
          .map((entry) => entry.key)
          .toList();

      if (featuresToRedeem.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No features selected to redeem'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Show confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Redemption'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You are about to redeem the following features:'),
              const SizedBox(height: 8),
              ...featuresToRedeem.map((feature) => Text('• $feature')),
              const SizedBox(height: 16),
              const Text(
                'This action cannot be undone. Continue?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0a519d),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Process redemptions
      List<String> successfulRedemptions = [];
      List<String> failedRedemptions = [];

      for (var featureName in featuresToRedeem) {
        try {
          await ref.read(reedemTicketfeaturesProvider((
            ticketId: widget.ticketId,
            featureName: featureName,
          )).future);
          successfulRedemptions.add(featureName);
        } catch (e) {
          log('Error redeeming feature $featureName: $e');
          failedRedemptions.add(featureName);
        }
      }

      // Show results
      if (mounted) {
        if (successfulRedemptions.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully redeemed: ${successfulRedemptions.join(', ')}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (failedRedemptions.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to redeem: ${failedRedemptions.join(', ')}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      // Refresh data
      await _onRefresh();
    } catch (e) {
      log('Error redeeming features: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to redeem features: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    if (!mounted) return;

    try {
      final newFeatures =
          await ref.refresh(ticketfeaturesProvider(widget.ticketId).future);

      if (mounted) {
        setState(() {
          featureStatus = {
            for (var feature in newFeatures) feature.name: feature.status
          };
        });
      }
    } catch (e) {
      log('Error refreshing features: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildFeatureCard(TicketFeaturesModel feature, int index) {
    final isCurrentlySelected = featureStatus[feature.name] ?? feature.status;
    final wasOriginallyRedeemed = feature.status;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isCurrentlySelected ? Colors.green : Colors.grey[300],
          child: Icon(
            isCurrentlySelected ? Icons.check : Icons.local_offer,
            color: isCurrentlySelected ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Text(
          feature.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration:
                wasOriginallyRedeemed ? TextDecoration.lineThrough : null,
            color: wasOriginallyRedeemed ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          wasOriginallyRedeemed
              ? 'Already redeemed'
              : 'Available for redemption',
          style: TextStyle(
            color: wasOriginallyRedeemed ? Colors.grey : Colors.blue[700],
            fontSize: 12,
          ),
        ),
        trailing: Checkbox(
          value: featureStatus[feature.name] ?? feature.status,
          onChanged: wasOriginallyRedeemed
              ? null
              : (bool? value) {
                  if (value != null && mounted) {
                    setState(() {
                      featureStatus[feature.name] = value;
                    });
                  }
                },
          activeColor: const Color(0xff0a519d),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuresProvider = ref.watch(ticketfeaturesProvider(widget.ticketId));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Features'),
          backgroundColor: const Color(0xff0a519d),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final canPop = await _onWillPop();
              if (canPop) {
                await _exitPage();
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: isSubmitting ? null : _onRefresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: featuresProvider.when(
          data: (features) {
            // Initialize feature status on first load
            if (isInitialLoad && mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    featureStatus = {
                      for (var feature in features) feature.name: feature.status
                    };
                    isInitialLoad = false;
                  });
                }
              });
            }

            // Check if all features are already redeemed
            if (features.isNotEmpty &&
                features.every((feature) => feature.status)) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'All Features Redeemed',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You have already redeemed all available features for this ticket.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _exitPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0a519d),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Show features list
            return features.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No features available for this ticket',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _exitPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0a519d),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: Colors.blue[50],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ticket ID: ${widget.ticketId.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Available Features: ${features.where((f) => !f.status).length}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: features.length,
                            itemBuilder: (context, index) {
                              return _buildFeatureCard(features[index], index);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () => _submitChanges(features),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff0a519d),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey,
                              ),
                              child: isSubmitting
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Processing...'),
                                      ],
                                    )
                                  : const Text(
                                      'Redeem Selected Features',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to Load Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _exitPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Go Back'),
                      ),
                      ElevatedButton(
                        onPressed: () => ref
                            .refresh(ticketfeaturesProvider(widget.ticketId)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0a519d),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xff0a519d),
                ),
                SizedBox(height: 16),
                Text('Loading ticket features...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
