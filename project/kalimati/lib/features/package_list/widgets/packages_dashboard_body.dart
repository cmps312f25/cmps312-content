import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/core/entities/enum/language_filter.dart';
import 'package:kalimati/core/entities/enum/level_filter.dart';
import 'package:kalimati/core/entities/user.dart';
import 'package:kalimati/features/auth/presentation/providers/auth_provider.dart';
import 'package:kalimati/features/package_list/widgets/package_card.dart';
import 'package:kalimati/core/providers/package_provider.dart';

class PackagesDashboardBody extends StatefulWidget {
  final bool loggedIn;
  final AsyncValue packageAsyncValue;
  final Color primaryGreen;
  final Color lightGreen;
  final Color textBlack;
  final WidgetRef ref;
  final User? currentUser;
  final int selectedViewIndex;
  final ValueChanged<int>? onViewChanged;

  const PackagesDashboardBody({
    required this.loggedIn,
    required this.packageAsyncValue,
    required this.primaryGreen,
    required this.lightGreen,
    required this.textBlack,
    required this.ref,
    this.currentUser,
    this.selectedViewIndex = 0,
    this.onViewChanged,
    super.key,
  });

  @override
  State<PackagesDashboardBody> createState() => _PackagesDashboardBodyState();
}

class _PackagesDashboardBodyState extends State<PackagesDashboardBody> {
  String _searchQuery = '';
  LevelFilter _selectedLevel = LevelFilter.all;
  LanguageFilter _selectedLanguage = LanguageFilter.all;
  String _selectedSort = 'A-Z';
  final List<String> _sortOptions = ['A-Z', 'Z-A'];

  bool get isMyPackages => widget.selectedViewIndex == 1;

  Future<void> _confirmDelete(LearningPackage package) async {
    const brandBg = Color.fromARGB(255, 243, 255, 243);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: brandBg,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          'Delete Package',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            children: [
              const TextSpan(text: 'Are you sure you want to delete the '),
              TextSpan(
                text: package.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const TextSpan(text: '? This action cannot be undone.'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.ref
          .read(packageNotifierProvider.notifier)
          .deletePackage(package);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Package deleted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double maxContentWidth = width > 1200 ? 900 : width * 0.9;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.loggedIn &&
                      widget.ref.read(currentUserProvider) != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF81C784), Color(0xFF388E3C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.waving_hand_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Welcome Back, ${widget.ref.read(currentUserProvider)!.firstName}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search packages...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: widget.primaryGreen,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: widget.primaryGreen.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: widget.primaryGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: [
                      _EnumDropdown<LanguageFilter>(
                        label: 'Language',
                        value: _selectedLanguage,
                        items: LanguageFilter.values,
                        onChanged: (val) =>
                            setState(() => _selectedLanguage = val!),
                        getLabel: (filter) => filter.label,
                      ),
                      _EnumDropdown<LevelFilter>(
                        label: 'Level',
                        value: _selectedLevel,
                        items: LevelFilter.values,
                        onChanged: (val) =>
                            setState(() => _selectedLevel = val!),
                        getLabel: (filter) => filter.label,
                      ),
                      _SimpleDropdown(
                        label: 'Sort',
                        value: _selectedSort,
                        items: _sortOptions,
                        onChanged: (val) =>
                            setState(() => _selectedSort = val!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: widget.packageAsyncValue.when(
                  data: (packageData) {
                    var packages =
                        (packageData.packages as List<LearningPackage>).where((
                          pkg,
                        ) {
                          if (isMyPackages) {
                            if (widget.currentUser?.email == null ||
                                pkg.author != widget.currentUser!.email) {
                              return false;
                            }
                          }
                          return pkg.title.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ) &&
                              (_selectedLanguage == LanguageFilter.all ||
                                  pkg.language == _selectedLanguage.label) &&
                              (_selectedLevel == LevelFilter.all ||
                                  pkg.level == _selectedLevel.label);
                        }).toList();
                    packages.sort(
                      (a, b) => _selectedSort == 'A-Z'
                          ? a.title.compareTo(b.title)
                          : b.title.compareTo(a.title),
                    );
                    if (packages.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            isMyPackages
                                ? 'No packages found.\nTap + to add a package.'
                                : 'No packages found.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.textBlack,
                            ),
                          ),
                        ),
                      );
                    }
                    if (width >= 800) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: width >= 1200 ? 1.3 : 0.9,
                          children: packages.map((package) {
                            return PackageCard(
                              user: widget.currentUser,
                              package: package,
                              primaryGreen: widget.primaryGreen,
                              textBlack: widget.textBlack,
                              onDelete: () => _confirmDelete(package),
                              onTap: () => widget.ref
                                  .read(packageNotifierProvider.notifier)
                                  .selectPackage(package),
                              onEdit: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/manageWordsPage');
                              },
                              onFlashcards: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/flashcards');
                              },
                              onUnscramble: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/unscramble');
                              },
                              onMatching: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/matching');
                              },
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          final package = packages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PackageCard(
                              user: widget.currentUser,
                              package: package,
                              primaryGreen: widget.primaryGreen,
                              textBlack: widget.textBlack,
                              onDelete: () => _confirmDelete(package),
                              onTap: () => widget.ref
                                  .read(packageNotifierProvider.notifier)
                                  .selectPackage(package),
                              onEdit: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/manageWordsPage');
                              },
                              onFlashcards: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/flashcards');
                              },
                              onUnscramble: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/unscramble');
                              },
                              onMatching: () {
                                widget.ref
                                    .read(packageNotifierProvider.notifier)
                                    .selectPackage(package);
                                context.push('/matching');
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  loading: () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: widget.primaryGreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  const _SimpleDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          icon: const Icon(Icons.arrow_drop_down_rounded),
        ),
      ),
    );
  }
}

class _EnumDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T) getLabel;
  const _EnumDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getLabel,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    getLabel(e),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          icon: const Icon(Icons.arrow_drop_down_rounded),
        ),
      ),
    );
  }
}
