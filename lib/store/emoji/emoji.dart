import 'package:beaver/core/business/emoji/favorite_emoji.dart';
import 'package:beaver/core/business/emoji/package.dart';
import 'package:beaver/core/business/emoji/package_emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class EmojiStoreState extends Equatable {
  final List<EmojiPackageModel> packageList;
  final List<FavoriteEmojiModel> favoriteEmojis;
  final Map<String, List<EmojiModel>> packageEmojisMap;
  final bool isLoading;

  const EmojiStoreState({
    this.packageList = const [],
    this.favoriteEmojis = const [],
    this.packageEmojisMap = const {},
    this.isLoading = false,
  });

  EmojiStoreState copyWith({
    List<EmojiPackageModel>? packageList,
    List<FavoriteEmojiModel>? favoriteEmojis,
    Map<String, List<EmojiModel>>? packageEmojisMap,
    bool? isLoading,
  }) {
    return EmojiStoreState(
      packageList: packageList ?? this.packageList,
      favoriteEmojis: favoriteEmojis ?? this.favoriteEmojis,
      packageEmojisMap: packageEmojisMap ?? this.packageEmojisMap,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [packageList, favoriteEmojis, packageEmojisMap, isLoading];
}

class EmojiStore extends Cubit<EmojiStoreState> {
  final FavoriteEmojiBusinessInterface _favoriteEmojiBusiness = getIt<FavoriteEmojiBusinessInterface>();
  final EmojiPackageBusinessInterface _packageBusiness = getIt<EmojiPackageBusinessInterface>();
  final PackageEmojiBusinessInterface _packageEmojiBusiness = getIt<PackageEmojiBusinessInterface>();

  EmojiStore() : super(const EmojiStoreState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final packages = await _packageBusiness.getEmojiPackages();
      final favorites = await _favoriteEmojiBusiness.getUserFavoriteEmojis();
      emit(state.copyWith(
        packageList: packages,
        favoriteEmojis: favorites,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadPackageEmojis(String packageId) async {
    if (state.packageEmojisMap.containsKey(packageId)) return;

    try {
      final emojis = await _packageEmojiBusiness.getPackageEmojis(packageId);
      final newMap = Map<String, List<EmojiModel>>.from(state.packageEmojisMap);
      newMap[packageId] = emojis;
      emit(state.copyWith(packageEmojisMap: newMap));
    } catch (e) {
      // 错误处理
    }
  }
}
