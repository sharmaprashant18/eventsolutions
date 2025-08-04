// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventsolutions/constants/refresh_indicator.dart';
import 'package:eventsolutions/provider/our_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicePage extends ConsumerWidget {
  const ServicePage(
      {super.key, required this.searchQuery, this.showAppBarTitle = true});
  final String searchQuery;
  final bool showAppBarTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(ourServicesProvider);
    final baseUrlImage = 'http://182.93.94.210:8001';

    return Scaffold(
      appBar: showAppBarTitle
          ? AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "Our Services",
                style: TextStyle(
                  color: Color(0xFF2D5A5A),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: RefreshScaffold(
        onRefresh: () async {
          ref.invalidate(ourServicesProvider);
          await Future.delayed(Duration(seconds: 2));
        },
        body: services.when(
          data: (data) {
            final filteredServices = data
                .where((service) =>
                    service.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    service.description
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

            if (filteredServices.isEmpty) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text('No events match your search.'),
                  ),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(top: showAppBarTitle ? 20 : 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF8FAFC),
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  clipBehavior: Clip.hardEdge,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final service = data[index];
                    // final imagePath = getImageForService(service.name);

                    return Container(
                      margin: EdgeInsets.only(
                        bottom: 15,
                        right: showAppBarTitle ? 10 : 0,
                        left: showAppBarTitle ? 10 : 0,
                      ),
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black.withAlpha(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  //   colors: [
                                  //     Color(0xFF00D4AA),
                                  //     Color(0xFF00C4B4),
                                  //   ],
                                  // ),
                                  color: Color(0xff0a519d),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff0a519d).withAlpha(30),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    service.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(10),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: '$baseUrlImage${service.image}',
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        width: 200,
                                        color: Colors.grey.shade300,
                                        child: Center(
                                          child: Icon(Icons.broken_image,
                                              size: 48, color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(17),
                                child: Text(
                                  service.description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          error: (error, stackTrace) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Image.asset('assets/wrong.png'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(ourServicesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          loading: () => SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
