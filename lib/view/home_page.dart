// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/services/auth_services/auth_service.dart';
import 'package:eventsolutions/view/about_us_page.dart';
import 'package:eventsolutions/view/contact_us_page.dart';
import 'package:eventsolutions/view/our_service_page.dart';
import 'package:eventsolutions/view/profile.dart';
import 'package:eventsolutions/view/ticket_qr.dart';
import 'package:eventsolutions/view/ongoing_events.dart';
import 'package:eventsolutions/view/faq.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:eventsolutions/view/stall_page.dart';
import 'package:eventsolutions/view/upcoming_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  DateTime? lastBackPressed;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Method to handle back button press
  void _handleBackPress(bool didPop, dynamic result) {
    if (didPop) return;

    // If searching, exit search mode first
    if (isSearching) {
      setState(() {
        isSearching = false;
        searchQuery = '';
        searchController.clear();
      });
      return;
    }

    if (tabController.index == 2) {
      tabController.animateTo(1);
      return;
    } else if (tabController.index == 1) {
      tabController.animateTo(0);
      return;
    } else if (tabController.index == 0) {
      final now = DateTime.now();
      if (lastBackPressed == null ||
          now.difference(lastBackPressed!) > const Duration(seconds: 1)) {
        lastBackPressed = now;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      SystemNavigator.pop();
    }
  }

  bool get _canPop {
    if (isSearching) return false;
    if (tabController.index != 0) return false;

    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 1)) {
      return false;
    }

    return true;
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchQuery = '';
        searchController.clear();
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: _handleBackPress,
      child: GestureDetector(
        onTap: () {
          if (isSearching) {
            setState(() {
              isSearching = false;
              searchQuery = '';
              searchController.clear();
            });
          }
        },
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.colorDodge),
                      image: const AssetImage('assets/event_solutions.png'),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 100, bottom: 20),
                ),
                const SizedBox(height: 10),
                _drawer(
                  context,
                  8,
                  ' Profile',
                  Icons.account_circle,
                ),
                _drawer(
                  context,
                  7,
                  ' My Ticket',
                  Icons.local_activity,
                ),
                _drawer(
                  context,
                  6,
                  'Our Services',
                  Icons.miscellaneous_services_rounded,
                ),
                // _drawer(
                //   context,
                //   5,
                //   'Stall',
                //   Icons.festival_rounded,
                // ),
                _drawer(
                  context,
                  0,
                  'About Us',
                  Icons.info,
                ),
                _drawer(
                  context,
                  1,
                  'Contact Us',
                  Icons.contact_page,
                ),
                _drawer(
                  context,
                  3,
                  'FAQ',
                  Icons.support_agent,
                ),
                _drawer(
                  context,
                  4,
                  'Log Out',
                  Icons.logout,
                ),
              ],
            ),
          ),
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.08,
            centerTitle: true,
            elevation: 0,
            actions: [
              if (isSearching)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8),
                    child: SearchBar(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      elevation: const WidgetStatePropertyAll(0),
                      controller: searchController,
                      hintText: 'Search events and services...',
                      autoFocus: true,
                      onChanged: _onSearchChanged,
                      leading: const Icon(Icons.search, color: Colors.grey),
                      trailing: [
                        if (searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              searchController.clear();
                              _onSearchChanged('');
                            },
                          ),
                      ],
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _toggleSearch,
                ),
            ],
            title: isSearching
                ? null
                : const Text(
                    'Events',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                // Show search results count when searching
                if (isSearching && searchQuery.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Searching for: "$searchQuery"',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Container(
                    height: screenHeight * 0.06,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      tabAlignment: TabAlignment.fill,
                      controller: tabController,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.grey,
                      padding: const EdgeInsets.all(9),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      unselectedLabelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(20),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      tabs: const [
                        Tab(text: 'ONGOING'),
                        Tab(text: 'UPCOMING'),
                        Tab(text: 'SERVICES'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      OngoingEvents(searchQuery: searchQuery),
                      UpcomingEvents(searchQuery: searchQuery),
                      ServicePage(
                        searchQuery: searchQuery,
                        showAppBarTitle: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context, int id, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 6),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            switch (id) {
              case 0:
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
                break;
              case 1:
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
                break;

              case 3:
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqPage()),
                );
                break;
              case 4:
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          child: const Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            AuthService().logout();
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
                break;
              // case 5:
              //   Navigator.pop(context);
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const StallPage(eventId: '')),
              //   );
              //   break;
              case 6:
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ServicePage(
                            searchQuery: '',
                          )),
                );
                break;
              case 7:
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TicketQr(ticketId: null)));
                break;
              case 8:
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
                break;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 25,
                color: Colors.green,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
