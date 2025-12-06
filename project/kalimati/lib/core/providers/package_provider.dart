import 'package:kalimati/core/repositories/learning_package_repo.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/core/providers/package_repo_providers.dart';

import 'package:riverpod/riverpod.dart';

class PackageData {
  List<LearningPackage> packages;
  LearningPackage? selectedPackage;

  PackageData({required this.packages, this.selectedPackage});
}

class PackageNotifier extends AsyncNotifier<PackageData> {
  late final LearningPackageRepo packageRepo;

  void selectPackage(LearningPackage package) {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(
        PackageData(packages: currentState.packages, selectedPackage: package),
      );
    }
  }

  @override
  Future<PackageData> build() async {
    packageRepo = await ref.read(packageRepoProvider.future);
    packageRepo.getPackages().listen((packages) {
      state = AsyncData(
        PackageData(
          packages: packages,
          selectedPackage: state.value?.selectedPackage,
        ),
      );
    });
    return PackageData(packages: []);
  }

  Future<void> addPackage(LearningPackage package) async {
    try {
      await packageRepo.addPackage(package);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePackage(LearningPackage package) async {
    try {
      await packageRepo.updatePackage(package);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePackage(LearningPackage category) async {
    try {
      await packageRepo.deletePackage(category);
    } catch (e) {
      rethrow;
    }
  }

  Future<LearningPackage?> getPackageById(String id) async {
    return await packageRepo.getPackageById(id);
  }

  Future<void> saveWord(Word newWord, {Word? originalWord}) async {
    final currentData = state.value;
    final selectedPackage = currentData?.selectedPackage;
    if (currentData == null || selectedPackage == null) {
      throw StateError('No package selected');
    }

    final updatedWords = List<Word>.from(selectedPackage.words);
    int existingIndex = -1;
    if (originalWord != null) {
      existingIndex = updatedWords.indexWhere(
        (word) => word.text.toLowerCase() == originalWord.text.toLowerCase(),
      );
    } else {
      existingIndex = updatedWords.indexWhere(
        (word) => word.text.toLowerCase() == newWord.text.toLowerCase(),
      );
    }

    if (existingIndex >= 0) {
      updatedWords[existingIndex] = newWord;
    } else {
      updatedWords.add(newWord);
    }

    final updatedPackage = LearningPackage(
      packageId: selectedPackage.packageId,
      author: selectedPackage.author,
      category: selectedPackage.category,
      description: selectedPackage.description,
      iconUrl: selectedPackage.iconUrl,
      keyWords: selectedPackage.keyWords == null
          ? null
          : List<String>.from(selectedPackage.keyWords!),
      language: selectedPackage.language,
      lastUpdateDate: DateTime.now(),
      level: selectedPackage.level,
      title: selectedPackage.title,
      version: selectedPackage.version + 1,
      words: updatedWords,
    );

    await _persistPackage(updatedPackage);
  }

  Future<void> removeWord(Word wordToRemove) async {
    final currentData = state.value;
    final selectedPackage = currentData?.selectedPackage;
    if (currentData == null || selectedPackage == null) {
      throw StateError('No package selected');
    }

    final updatedWords = selectedPackage.words
        .where(
          (word) => word.text.toLowerCase() != wordToRemove.text.toLowerCase(),
        )
        .toList();

    final updatedPackage = LearningPackage(
      packageId: selectedPackage.packageId,
      author: selectedPackage.author,
      category: selectedPackage.category,
      description: selectedPackage.description,
      iconUrl: selectedPackage.iconUrl,
      keyWords: selectedPackage.keyWords == null
          ? null
          : List<String>.from(selectedPackage.keyWords!),
      language: selectedPackage.language,
      lastUpdateDate: DateTime.now(),
      level: selectedPackage.level,
      title: selectedPackage.title,
      version: selectedPackage.version + 1,
      words: updatedWords,
    );

    await _persistPackage(updatedPackage);
  }

  Future<void> updateSelectedPackage(LearningPackage updatedPackage) async {
    await _persistPackage(updatedPackage);
  }

  Future<void> _persistPackage(LearningPackage updatedPackage) async {
    final currentData = state.value;
    final packages = currentData?.packages ?? [];
    final exists = packages.any(
      (pkg) => pkg.packageId == updatedPackage.packageId,
    );

    if (exists) {
      await packageRepo.updatePackage(updatedPackage);
    } else {
      await packageRepo.addPackage(updatedPackage);
    }

    _updateSelectedInMemory(updatedPackage, exists);
  }

  void _updateSelectedInMemory(
    LearningPackage updatedPackage,
    bool existedBefore,
  ) {
    final currentData = state.value;
    final packages = currentData?.packages ?? [];

    final updatedPackages = existedBefore
        ? packages
              .map(
                (pkg) => pkg.packageId == updatedPackage.packageId
                    ? updatedPackage
                    : pkg,
              )
              .toList()
        : [...packages, updatedPackage];

    state = AsyncData(
      PackageData(packages: updatedPackages, selectedPackage: updatedPackage),
    );
  }
}

final packageNotifierProvider =
    AsyncNotifierProvider<PackageNotifier, PackageData>(
      () => PackageNotifier(),
    );
