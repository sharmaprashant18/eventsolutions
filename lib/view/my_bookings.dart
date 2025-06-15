import 'package:eventsolutions/model/stall/user_booking_details_model.dart';
import 'package:eventsolutions/provider/stall_provider.dart';
import 'package:eventsolutions/view/pay_again.dart';
import 'package:eventsolutions/view/stall_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBookingDetailsScreen extends ConsumerWidget {
  const UserBookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsyncValue = ref.watch(userBookingdetailsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff50d99b),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bookingAsyncValue.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No bookings found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userBookingdetailsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(booking: booking);
              },
            ),
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E3B62)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading your bookings...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load bookings',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userBookingdetailsProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3B62),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final UserBookingDetailsModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with event name and status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withAlpha(10),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.eventName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3B62),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booking ID: ${booking.bookingId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(booking.status),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Info
                _buildSectionTitle('Business Information'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.business, booking.businessInfo.name),
                _buildInfoRow(Icons.phone, booking.businessInfo.phone),
                _buildInfoRow(Icons.email, booking.businessInfo.email),

                const SizedBox(height: 16),

                // Contact Info
                _buildSectionTitle('Contact Information'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, booking.contactInfo.name),
                _buildInfoRow(Icons.phone, booking.contactInfo.phone),
                _buildInfoRow(Icons.email, booking.contactInfo.email),

                const SizedBox(height: 16),

                // Stall Information
                _buildSectionTitle('Stall Details'),
                const SizedBox(height: 8),
                ...booking.stallInfo.map((stall) => _buildStallCard(stall)),

                const SizedBox(height: 16),

                // Payment Information
                _buildSectionTitle('Payment Details'),
                const SizedBox(height: 8),
                _buildPaymentSummary(context),

                const SizedBox(height: 16),

                // Payment History
                if (booking.payments.isNotEmpty) ...[
                  _buildSectionTitle('Payment History'),
                  const SizedBox(height: 8),
                  ...booking.payments
                      .map((payment) => _buildPaymentItem(payment)),
                ],

                // Cancel Reason (if applicable)
                if (booking.bookingCancelReason.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle('Cancellation Reason'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      booking.bookingCancelReason,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E3B62),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStallCard(BookingStallInfo stall) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stall.stallType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3B62),
                ),
              ),
              Text(
                'Rs. ${stall.rate.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Stall ID: ${stall.stallId}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Size: ${stall.sizeInSqFt} sq ft',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount:'),
              Text(
                'Rs. ${booking.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending Amount:'),
              Text(
                'Rs. ${booking.pendingAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: booking.pendingAmount > 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment Status:'),
              _buildStatusChip(booking.paymentStatus),
            ],
          ),
          if (booking.paymentStatus.toLowerCase() == 'remaining') ...[
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PayAgain(
                          bookingId: booking.bookingId,
                          pendingAmount: booking.pendingAmount),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3B62),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Pay Again'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentItem(BookingPayments payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment ID: ${payment.paymentId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Method: ${payment.paymentMethod}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Date: ${payment.paymentDate}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              _buildStatusChip(payment.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      case 'hold':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
