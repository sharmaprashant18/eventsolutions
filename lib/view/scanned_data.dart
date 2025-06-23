// ignore_for_file: use_build_context_synchronously

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

  Future<void> _submitChanges(
      List<TicketFeaturesModel> originalFeatures) async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No features selected to redeem')),
        );
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      for (var featureName in featuresToRedeem) {
        try {
          await ref.read(reedemTicketfeaturesProvider((
            ticketId: widget.ticketId,
            featureName: featureName,
          )).future);
        } catch (e) {
          log('Error redeeming feature $featureName: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to redeem feature $featureName: $e')),
          );
          setState(() {
            isSubmitting = false;
          });
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Features redeemed successfully')),
      );

      await _onRefresh();
    } catch (e) {
      log('Error redeeming features: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to redeem features: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    final newFeatures =
        await ref.refresh(ticketfeaturesProvider(widget.ticketId).future);

    setState(() {
      featureStatus = {
        for (var feature in newFeatures) feature.name: feature.status
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final featuresProvider = ref.watch(ticketfeaturesProvider(widget.ticketId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Features'),
      ),
      body: featuresProvider.when(
        data: (features) {
          if (featureStatus.isEmpty) {
            featureStatus = {
              for (var feature in features) feature.name: feature.status
            };
          }
          if (features.isNotEmpty &&
              features.every((feature) => features[0].status)) {
            return const Center(
              child: Text(
                'Your Features are already redeemed',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }
          return features.isEmpty
              ? const Center(child: Text('No features Available'))
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: features.length,
                          itemBuilder: (context, index) {
                            final feature = features[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(feature.name),
                                trailing: Checkbox(
                                  value: featureStatus[feature.name] ??
                                      feature.status,
                                  onChanged: featureStatus[feature.name] == true
                                      ? null
                                      : (bool? value) {
                                          if (value != null) {
                                            setState(() {
                                              featureStatus[feature.name] =
                                                  value;
                                            });
                                          }
                                        },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () => _submitChanges(features),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: const Color(0xff0a519d),
                            foregroundColor: Colors.white,
                          ),
                          child: isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Submit Changes'),
                        ),
                      ),
                    ],
                  ),
                );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to get the features: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(ticketfeaturesProvider(widget.ticketId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
