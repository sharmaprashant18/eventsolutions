import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class OurTeamPage extends ConsumerStatefulWidget {
  const OurTeamPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OurTeamPageState();
}

class _OurTeamPageState extends ConsumerState<OurTeamPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _startAutoSlide(int totalMembers) {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        _currentPage = (_currentPage + 1) % totalMembers;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamMembers = ref.watch(teamProvider);
    final baseUrlImage = 'http://182.93.94.210:8001';
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: const Color(0xff0a519d),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0a519d), Color(0xff1e40af)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Our Team',
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff8fafc), Color(0xffe2e8f0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.02,
              left: screenWidth * 0.05,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    // padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      '''Our team believes in working as a team to achieve the greatest outcomes, and their professional expertise working in this industry for many years has set our own benchmark with the best client ratings. We have established a benchmark in the exhibition planning, helping the corporate sector to reach new heights.''',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.8,
                        fontFamily: 'Inter',
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                teamMembers.when(
                  data: (teamData) {
                    if (teamData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Team Members',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        height: screenHeight * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff0a519d).withAlpha(20),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff0a519d),
                                  Color(0xff1e40af),
                                  Color(0xff3b82f6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: teamData.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final team = teamData[index];

                                    if (index == 0) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _startAutoSlide(teamData.length);
                                      });
                                    }
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withAlpha(30),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              height: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withAlpha(80),
                                                  width: 4,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: team.photo
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? '$baseUrlImage${team.photo}'
                                                      : 'assets/error.png',
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, error,
                                                          stackTrace) =>
                                                      Container(
                                                    height: 200,
                                                    width: 200,
                                                    color: Colors.grey.shade300,
                                                    child: Center(
                                                      child: Icon(
                                                          Icons.broken_image,
                                                          size: 48,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(15),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color:
                                                    Colors.white.withAlpha(30),
                                              ),
                                            ),
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${team.name.toUpperCase()}\n',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: team.position,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                          .withAlpha(90),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          InkWell(
                                            onTap: () {
                                              launchUrl(
                                                mode: LaunchMode
                                                    .externalApplication,
                                                Uri.parse(
                                                    "mailto:${team.email}?subject=Want to contact you&body=Hello, I would like to..."),
                                              );
                                              debugPrint("Email link tapped");
                                            },
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.white.withAlpha(10),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withAlpha(30),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.email,
                                                      size: 16,
                                                      color: Color(0xff0a519d),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    team.email,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              _buildSocialButton(
                                                onTap: () {
                                                  launchUrl(Uri.parse(team
                                                          .socialLinks
                                                          .facebook ??
                                                      'N/A'));
                                                  log("Facebook link tapped");
                                                },
                                                icon: 'assets/facebook.png',
                                                color: const Color(0xff1877f2),
                                              ),
                                              const SizedBox(width: 16),
                                              _buildSocialButton(
                                                onTap: () {
                                                  launchUrl(Uri.parse(team
                                                          .socialLinks
                                                          .personal ??
                                                      'N/A'));
                                                  log("Instagram link tapped");
                                                },
                                                icon: 'assets/insta.png',
                                                color: const Color(0xffe4405f),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            team.description,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              letterSpacing: 0.8,
                                              height: 1.5,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      teamData.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        width: _currentPage == index ? 24 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _currentPage == index
                                              ? Colors.white
                                              : Colors.white.withAlpha(40),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.red.shade200,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Failed to load team members',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  error.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff0a519d)),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading team members...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff0a519d),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.03), // Extra padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(30),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: color.withAlpha(20),
            width: 2,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                color.withAlpha(10),
                color.withAlpha(5),
              ],
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
