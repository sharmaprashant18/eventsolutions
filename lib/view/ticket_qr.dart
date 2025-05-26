// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventsolutions/services/event_services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventsolutions/model/ticket_model.dart';

class TicketQr extends ConsumerWidget {
  final String? ticketId; // Optional parameter for direct navigation

  const TicketQr({super.key, this.ticketId});

  Future<List<String>> _getAllTicketIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('allTicketIds') ?? [];
  }

  Future<List<TicketData>> _getAllTicketDetails(EventServices service) async {
    final ticketIds = await _getAllTicketIds();

    // Fetch ticket data for each ID
    final List<TicketData> ticketDataList = [];
    for (final id in ticketIds) {
      try {
        final ticket = await service.fetchTicketDetailsById(id);
        ticketDataList.add(ticket);
      } catch (e) {
        debugPrint("Failed to load ticket with ID $id: $e");
      }
    }

    return ticketDataList;
  }

  Future<void> _savePdfFile(BuildContext context, TicketData ticket) async {
    try {
      final pdf = pw.Document();
      final baseUrl = 'http://182.93.94.210:8000';

      Uint8List? qrImageBytes;
      if (ticket.qr != null) {
        final response = await Dio().get<List<int>>(
          '$baseUrl${ticket.qr}',
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.statusCode == 200) {
          qrImageBytes = Uint8List.fromList(response.data!);
        }
      }

      _getStatusColor(ticket.status);
      final statusText = ticket.status.toUpperCase();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a6,
          build: (pw.Context context) {
            return pw.Container(
              padding: pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      ticket.eventName,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Center(
                    child: pw.Container(
                      padding:
                          pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.lightBlue100,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Text(
                        'ID: ${ticket.ticketId}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: pw.Font.courier(),
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (qrImageBytes != null)
                    pw.Center(
                      child: pw.Image(
                        pw.MemoryImage(qrImageBytes),
                        width: 100,
                        height: 100,
                      ),
                    ),
                  pw.SizedBox(height: 10),
                  pw.Text('Name: ${ticket.name}',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Email: ${ticket.email}',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Phone: ${ticket.number}',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        width: 1,
                      ),
                    ),
                    child: pw.Text(
                      'STATUS: $statusText',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Save the file logic
      Directory? directory;

      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> folders = directory!.path.split("/");
        for (int i = 1; i < folders.length; i++) {
          String folder = folders[i];
          if (folder == "Android") break;
          newPath += "/$folder";
        }
        newPath += "/Download";
        directory = Directory(newPath);
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/${ticket.ticketId}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket saved to $filePath')),
      );
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save ticket')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketService = ref.read(eventServiceProvider);

    return FutureBuilder<List<TicketData>>(
      future: _getAllTicketDetails(ticketService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading your tickets...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final tickets = snapshot.data!;
        final baseUrl = 'http://182.93.94.210:8000';

        return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'My Tickets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              elevation: 0),
          body: tickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No tickets found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your tickets will appear here once you purchase them',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    final statusColor = _getStatusColor(ticket.status);
                    final statusIcon = _getStatusIcon(ticket.status);

                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              width: double.infinity,
                              padding: EdgeInsets.only(bottom: 10, top: 5),
                              decoration: BoxDecoration(
                                  // color: Color(0xff83C8E4)
                                  color: Color(0xffD5E8F2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    ticket.eventName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(51),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'ID: ${ticket.ticketId}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        // color: Colors.white.withAlpha(230),
                                        color: Colors.black,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: ticket.status == 'approved' &&
                                      ticket.qr != null
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // QR Code
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.grey[200]!,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  '$baseUrl${ticket.qr}',
                                                  height: 120,
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),

                                            // User Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 18,
                                                        color: Colors.grey[600],
                                                      ),
                                                      SizedBox(width: 6),
                                                      Expanded(
                                                        child: Text(
                                                          ticket.name,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.email_outlined,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Expanded(
                                                        child: Text(
                                                          ticket.email,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.phone_outlined,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        ticket.number,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),

                                        // Status Badge
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: statusColor.withAlpha(25),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: statusColor.withAlpha(76),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                statusIcon,
                                                color: statusColor,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Status: ${ticket.status}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                  onPressed: () => _savePdfFile(
                                                      context, ticket),
                                                  icon: Icon(Icons.download))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(25),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: statusColor.withAlpha(76),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            statusIcon,
                                            color: statusColor,
                                            size: 32,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            ticket.status == 'pending'
                                                ? 'Pending Approval'
                                                : ticket.status.toUpperCase(),
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (ticket.status == 'pending')
                                            Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text(
                                                'Your ticket is being reviewed',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
