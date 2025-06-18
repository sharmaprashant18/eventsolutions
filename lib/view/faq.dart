// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FAQs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              dropDown(
                'How do I reset my password?',
                'Go to the Login page and click on "Forgot Password". Enter your registered email address, and you will receive the code in your registered email follow the instructions sent to your email.',
              ),
              dropDown('How do I contact support?',
                  'You can contact support via the contact us section.'),
              dropDown('Where can I find my ticket?',
                  'All your tickets are located under the My Tickets section.'),
              dropDown('Why Event Solutions is not responding?',
                  'Please ensure you have a stable internet connection and try refreshing the app.'),
              dropDown('How can I join the event?',
                  'You can join the event by clicking on the "Join" button in the event details section.'),
              dropDown('How do I pay the fee for the event?',
                  'You can go to the join button and there is a payment option available. Pay the fee and send the screenshot of the payment.'),
              dropDown('How long does the payment verification takes?',
                  "Once you have paid the fee, it usually takes 24-48 hours for the payment to be verified.."),
              dropDown('How can I get a refund?',
                  'You can request a refund by contacting support within 14 days of your purchase. Please provide your order details for faster processing.'),
              dropDown('How to download my ticket?',
                  'There is download option in the My Tickets section. You can download your ticket from the My Tickets section.')
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDown(String question, String answer, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        // color: const Color.fromARGB(255, 188, 248, 219),
        color: Color(0xff0a519d),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              // color: const Color.fromARGB(255, 188, 248, 219),
              color: Color(0xff0a519d),

              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  question,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      answer,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
