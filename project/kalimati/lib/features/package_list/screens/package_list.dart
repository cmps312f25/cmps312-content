import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/features/auth/presentation/providers/auth_provider.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'package:kalimati/features/package_list/widgets/navigation_drawer.dart';
import 'package:kalimati/features/package_list/widgets/packages_dashboard_body.dart';

class PackageList extends ConsumerStatefulWidget {
  const PackageList({super.key});

  @override
  ConsumerState<PackageList> createState() => _PackageListState();
}

class _PackageListState extends ConsumerState<PackageList> {
  int _selectedViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final loggedIn = ref.watch(isAuthenticatedProvider);
    final packageAsyncValue = ref.watch(packageNotifierProvider);
    final primaryGreen = Colors.green.shade600;
    final lightGreen = Colors.green.shade100;
    final textBlack = Colors.black87;
    final width = MediaQuery.of(context).size.width;
    final showRail = width >= 800;
    final isMobile = width < 600;

    // Reset to "All Packages" view if user logs out
    if (!loggedIn && _selectedViewIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedViewIndex = 0);
      });
    }

    return Scaffold(
      drawer: showRail
          ? null
          : CustomNavigationDrawer(
              loggedIn: loggedIn,
              user: currentUser,
              onLogout: () {
                ref.read(authNotifierProvider.notifier).signOut();
                context.go("/");
              },
            ),
      backgroundColor: const Color(0xFFFAF8F4),
      appBar: isMobile
          ? AppBar(
              elevation: 3,
              shadowColor: Colors.black26,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: const Text(
                'Packages',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: loggedIn
                  ? [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: 'Logout',
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).signOut();
                          context.go("/");
                        },
                      ),
                    ]
                  : [],
            )
          : null,
      body: Row(
        children: [
          if (showRail)
            NavigationRail(
              selectedIndex: loggedIn ? _selectedViewIndex : 0,
              onDestinationSelected: (index) {
                if (loggedIn) {
                  setState(() => _selectedViewIndex = index);
                }
              },
              backgroundColor: Colors.green.shade50,
              leading: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (currentUser?.photoUrl != null &&
                              currentUser!.photoUrl.isNotEmpty)
                          ? NetworkImage(currentUser.photoUrl)
                          : null,
                      child:
                          (currentUser?.photoUrl == null ||
                              currentUser!.photoUrl.isEmpty)
                          ? Icon(Icons.person, color: primaryGreen, size: 26)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentUser?.firstName ?? 'Guest',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: Text('All Packages'),
                ),
                if (loggedIn)
                  const NavigationRailDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon: Icon(Icons.inventory_2),
                    label: Text('My Packages'),
                  ),
              ],
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (currentUser?.id != null)
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: primaryGreen,
                          size: 30,
                        ),
                        tooltip: 'Add Package',
                        onPressed: () {
                          final placeholder = LearningPackage(
                            packageId:
                                'temp-${DateTime.now().millisecondsSinceEpoch}',
                            author: currentUser!.email,
                            category: '',
                            description: '',
                            iconUrl: '',
                            keyWords: const [],
                            language: '',
                            lastUpdateDate: DateTime.now(),
                            level: '',
                            title: 'Untitled Package',
                            version: 1,
                            words: const <Word>[],
                          );
                          ref
                              .read(packageNotifierProvider.notifier)
                              .selectPackage(placeholder);
                          context.push('/manageWordsPage');
                        },
                      ),
                    const SizedBox(height: 10),
                    IconButton(
                      icon: Icon(
                        loggedIn ? Icons.logout : Icons.login,
                        color: loggedIn ? Colors.red : primaryGreen,
                      ),
                      tooltip: loggedIn ? 'Logout' : 'Login',
                      onPressed: () {
                        if (loggedIn) {
                          ref.read(authNotifierProvider.notifier).signOut();
                          context.go('/');
                        } else {
                          context.go('/login');
                        }
                      },
                    ),
                  ],
                ),
              ),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: primaryGreen, size: 28),
              unselectedIconTheme: IconThemeData(
                color: Colors.grey.shade600,
                size: 24,
              ),
              selectedLabelTextStyle: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          Expanded(
            child: PackagesDashboardBody(
              loggedIn: loggedIn,
              currentUser: currentUser,
              packageAsyncValue: packageAsyncValue,
              primaryGreen: primaryGreen,
              lightGreen: lightGreen,
              textBlack: textBlack,
              ref: ref,
              selectedViewIndex: loggedIn ? _selectedViewIndex : 0,
              onViewChanged: (index) {
                if (loggedIn) {
                  setState(() => _selectedViewIndex = index);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: showRail || currentUser?.id == null
          ? null
          : FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: primaryGreen,
              onPressed: () {
                if (currentUser?.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Log in to add a package.')),
                  );
                  return;
                }
                final placeholder = LearningPackage(
                  packageId: 'temp-${DateTime.now().millisecondsSinceEpoch}',
                  author: currentUser!.email,
                  category: '',
                  description: '',
                  iconUrl: '',
                  keyWords: const [],
                  language: '',
                  lastUpdateDate: DateTime.now(),
                  level: '',
                  title: 'Untitled Package',
                  version: 1,
                  words: const <Word>[],
                );
                ref
                    .read(packageNotifierProvider.notifier)
                    .selectPackage(placeholder);
                context.push('/manageWordsPage');
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
      bottomNavigationBar: isMobile && loggedIn
          ? BottomNavigationBar(
              currentIndex: _selectedViewIndex,
              onTap: (index) {
                setState(() => _selectedViewIndex = index);
              },
              selectedItemColor: primaryGreen,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.book_outlined),
                  label: 'All Packages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: 'My Packages',
                ),
              ],
            )
          : null,
    );
  }
}
