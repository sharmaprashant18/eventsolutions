import 'package:eventsolutions/provider/event/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TicketQr extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketQr({super.key, required this.ticketId});

  @override
  _TicketQrState createState() => _TicketQrState();
}

class _TicketQrState extends ConsumerState<TicketQr> {
  Timer? _pollingTimer;
  String? _cachedQr;

  @override
  void initState() {
    super.initState();
    _loadCachedQr();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  // Load cached QR code from SharedPreferences
  Future<void> _loadCachedQr() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cachedQr = prefs.getString('qr_${widget.ticketId}');
      debugPrint(_cachedQr);
    });
  }

  // Save QR code to SharedPreferences
  Future<void> _saveQr(String qr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qr_${widget.ticketId}', qr);
    setState(() {
      _cachedQr = qr;
    });
  }

  // Start polling to check ticket status periodically
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final ticketAsync = ref.read(ticketProvider(widget.ticketId));
      ticketAsync.when(
        data: (ticket) {
          if (ticket.status.toLowerCase() == 'approved' && ticket.qr != null) {
            _saveQr(ticket.qr!); // Save QR code when approved
            timer.cancel(); // Stop polling once approved
          }
        },
        loading: () {},
        error: (err, stack) {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketAsync = ref.watch(ticketProvider(widget.ticketId));

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket QR Code')),
      body: ticketAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (ticket) {
          if (ticket.status.toLowerCase() == 'approved') {
            if (ticket.qr != null) {
              // Save QR code if not already cached
              if (_cachedQr == null) {
                _saveQr(ticket.qr!);
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your QR Code:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Image.network(
                      ticket.qr!,
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'Failed to load QR code.',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Scan this QR code at the event.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('QR code not available.'));
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ticket is pending approval.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please wait for admin approval. You will see the QR code once approved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref.refresh(ticketProvider(widget.ticketId));
                    },
                    child: const Text('Refresh Status'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
