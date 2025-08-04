// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:eventsolutions/model/events/event_by_event_id.dart';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class EventById extends ConsumerStatefulWidget {
  const EventById({super.key, required this.eventId});
  final String eventId;

  @override
  ConsumerState<EventById> createState() => _EventByIdState();
}

class _EventByIdState extends ConsumerState<EventById> {
  Future<void> _downloadPdf(String pdfUrl, String fileName) async {
    try {
      // Check current permission status
      PermissionStatus status = await Permission.storage.status;

      // For Android 13+ (API 33+), we don't need storage permission for Downloads
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          // Android 13+ doesn't require storage permission for Downloads folder
          await _performDownload(pdfUrl, fileName);
          return;
        }
      }

      // Handle permission for older Android versions and iOS
      if (status.isDenied) {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        _showPermissionDeniedDialog();
        return;
      }

      if (status.isPermanentlyDenied) {
        _showPermanentlyDeniedDialog();
        return;
      }

      if (status.isGranted) {
        await _performDownload(pdfUrl, fileName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _performDownload(String pdfUrl, String fileName) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Downloading PDF...'),
            ],
          ),
        ),
      );

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final filePath = '${directory.path}/$fileName.pdf';

        Dio dio = Dio();
        await dio.download(pdfUrl, filePath);

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF downloaded successfully!'),
            backgroundColor: Color(0xff0a519d),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Storage permission is required to download files. Please grant permission and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final status = await Permission.storage.request();
              if (status.isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Permission granted! Please try downloading again.')),
                );
              }
            },
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Storage permission is permanently denied. Please enable it in app settings to download files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventByEventIdProvider(widget.eventId));
    // final user = ref.watch(userDetailsProvider);
    return Scaffold(
      body: eventAsync.when(
        data: (event) => _buildEventDetails(context, event),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context, EventByEventId event) {
    final baseUrlImage = 'http://182.93.94.210:8001';
    final user = ref.watch(userDetailsProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 300,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,

                  // color: Colors.white,
                  color: Color(0xff0a519d),
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: baseUrlImage + event.poster!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(200)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.proposal == null || event.proposal!.isEmpty)
                  const SizedBox.shrink()
                else
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Event Proposal',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.download),
                                                  onPressed: () {
                                                    _downloadPdf(
                                                        '$baseUrlImage${event.proposal}',
                                                        '${event.title}_proposal');
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Expanded(
                                          child: SfPdfViewer.network(
                                            interactionMode:
                                                PdfInteractionMode.pan,
                                            enableDoubleTapZooming: true,
                                            enableDocumentLinkAnnotation: true,
                                            enableHyperlinkNavigation: true,
                                            enableTextSelection: true,
                                            canShowScrollHead: true,
                                            '$baseUrlImage${event.proposal}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            "View Proposal",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.wavy,
                                decorationColor: Colors.blue,
                                decorationThickness: 2,
                                color: const Color(0xff0a519d)),
                          ),
                        ),
                        // const SizedBox(width: 16),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            _downloadPdf('$baseUrlImage${event.proposal}',
                                '${event.title}_proposal');
                          },
                          icon: const Icon(
                            Icons.download,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text("Download Proposal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0a519d),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                _buildDescriptionCard(event),
                const SizedBox(height: 16),
                _buildEventInfoCard(event),
                const SizedBox(height: 16),
                _buildScheduleCard(event),
                const SizedBox(height: 16),
                _buildLocationCard(event),
                SizedBox(
                  height: 14,
                ),
                Center(
                  child: Column(
                    children: [
                      if ((event.organizer != null &&
                              event.organizer!.trim().isNotEmpty) ||
                          (event.organizerLogo != null &&
                              event.organizerLogo!.trim().isNotEmpty))
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              if (event.organizer != null &&
                                  event.organizer!.trim().isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Organized By:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        event.organizer!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (event.organizerLogo != null &&
                                  event.organizerLogo!.trim().isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl: baseUrlImage +
                                      (event.organizerLogo ?? ""),
                                  errorWidget: (context, error, stackTrace) =>
                                      SizedBox.shrink(),
                                ),
                            ],
                          ),
                        ),
                      if ((event.organizer != null &&
                              event.organizer!.trim().isNotEmpty) ||
                          (event.organizerLogo != null &&
                              event.organizerLogo!.trim().isNotEmpty))
                        SizedBox(height: 16),
                      if ((event.managedBy != null &&
                              event.managedBy!.trim().isNotEmpty) ||
                          (event.managedByLogo != null &&
                              event.managedByLogo!.trim().isNotEmpty))
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              if (event.managedBy != null &&
                                  event.managedBy!.trim().isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Managed By: ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      FittedBox(
                                        child: Text(
                                          event.managedBy!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (event.managedByLogo != null &&
                                  event.managedByLogo!.trim().isNotEmpty)
                                CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: baseUrlImage +
                                      (event.managedByLogo ?? ""),
                                  errorWidget: (context, error, stackTrace) =>
                                      Center(
                                    child: Icon(Icons.broken_image,
                                        size: 48, color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfoCard(EventByEventId event) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Details',
              style: TextStyle(
                  color: Color(0xff0a519d),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 8),
            // _buildInfoRow(Icons.event, 'Type', event.eventType),
            _buildInfoRow(
                label: 'Entry',
                value: event.entryType.isEmpty
                    ? 'N/A'
                    : event.entryType.toUpperCase()),
            _buildInfoRow(
                // icon: Icons.date_range,
                label: 'Start Day',
                value: _formatDate(event.startDate)),
            _buildInfoRow(
                // icon: Icons.date_range,
                label: 'End Day',
                value: _formatDate(event.endDate)),
            _buildInfoRow(
                // icon: Icons.event_available,
                label: 'Registration Opening Day',
                value: _formatDate(event.registrationOpen ?? 'N/A')),
            _buildInfoRow(
                // icon: Icons.event_busy,
                label: 'Registration Closing Day',
                value: _formatDate(event.registrationClose ?? 'N/A')),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(EventByEventId event) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                  color: Color(0xff0a519d),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(EventByEventId event) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule Time',
              style: TextStyle(
                  color: Color(0xff0a519d),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
                icon: Icons.schedule,
                label: 'Start',
                value: _formatDate(event.scheduleStart)),
            _buildInfoRow(
                icon: Icons.schedule,
                label: 'End',
                value: _formatDate(event.scheduleEnd))
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(EventByEventId event) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                  color: Color(0xff0a519d),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
                icon: Icons.location_on, label: 'Venue', value: event.location),
            if (event.googleMapUrl != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.map,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse(event.googleMapUrl ?? ''));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xff0a519d))),
                    label: Text(
                      "View on Map",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      {IconData? icon,
      String? text,
      required String label,
      required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.grey.shade500,
            )
          else if (text != null)
            Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          if (icon != null || text != null) const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMM d, yyyy ').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}
