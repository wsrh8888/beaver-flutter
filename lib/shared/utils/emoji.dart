class EmojiItem {
  final String name;
  final String path;
  final bool isImage;

  const EmojiItem({required this.name, required this.path, this.isImage = true});
}

const defaultEmojiList = [
  EmojiItem(name: '[微笑]', path: 'assets/images/emoji/微笑-1.png'),
  EmojiItem(name: '[亲吻]', path: 'assets/images/emoji/亲吻.png'),
  EmojiItem(name: '[亲吻1]', path: 'assets/images/emoji/亲吻-1.png'),
  EmojiItem(name: '[亲吻2]', path: 'assets/images/emoji/亲吻-2.png'),
  EmojiItem(name: '[睡觉]', path: 'assets/images/emoji/睡觉.png'),
  EmojiItem(name: '[生病]', path: 'assets/images/emoji/生病.png'),
  EmojiItem(name: '[震惊]', path: 'assets/images/emoji/震惊-1.png'),
  EmojiItem(name: '[害怕]', path: 'assets/images/emoji/害怕.png'),
  EmojiItem(name: '[害怕1]', path: 'assets/images/emoji/害怕-1.png'),
  EmojiItem(name: '[闭嘴]', path: 'assets/images/emoji/闭嘴.png'),
  EmojiItem(name: '[难过]', path: 'assets/images/emoji/难过.png'),
  EmojiItem(name: '[难过1]', path: 'assets/images/emoji/难过-1.png'),
  EmojiItem(name: '[静音]', path: 'assets/images/emoji/静音.png'),
  EmojiItem(name: '[面无表情]', path: 'assets/images/emoji/面无表情.png'),
  EmojiItem(name: '[面无表情1]', path: 'assets/images/emoji/面无表情-1.png'),
  EmojiItem(name: '[口罩]', path: 'assets/images/emoji/口罩.png'),
  EmojiItem(name: '[热恋]', path: 'assets/images/emoji/热恋.png'),
  EmojiItem(name: '[笑哭]', path: 'assets/images/emoji/笑哭.png'),
  EmojiItem(name: '[受伤]', path: 'assets/images/emoji/受伤.png'),
  EmojiItem(name: '[开心]', path: 'assets/images/emoji/开心.png'),
  EmojiItem(name: '[开心1]', path: 'assets/images/emoji/开心-1.png'),
  EmojiItem(name: '[开心2]', path: 'assets/images/emoji/开心-2.png'),
  EmojiItem(name: '[懵B]', path: 'assets/images/emoji/懵B.png'),
  EmojiItem(name: '[魔鬼]', path: 'assets/images/emoji/魔鬼.png'),
  EmojiItem(name: '[哭]', path: 'assets/images/emoji/哭.png'),
  EmojiItem(name: '[哭1]', path: 'assets/images/emoji/哭-1.png'),
  EmojiItem(name: '[头晕]', path: 'assets/images/emoji/头晕.png'),
  EmojiItem(name: '[酷]', path: 'assets/images/emoji/酷.png'),
  EmojiItem(name: '[酷1]', path: 'assets/images/emoji/酷-1.png'),
  EmojiItem(name: '[生气]', path: 'assets/images/emoji/生气.png'),
  EmojiItem(name: '[迷茫]', path: 'assets/images/emoji/迷茫.png'),
  EmojiItem(name: '[中毒]', path: 'assets/images/emoji/中毒.png'),
  EmojiItem(name: '[中毒1]', path: 'assets/images/emoji/中毒-1.png'),
  EmojiItem(name: '[天使]', path: 'assets/images/emoji/天使.png'),
  EmojiItem(name: '[眼红]', path: 'assets/images/emoji/眼红.png'),
  EmojiItem(name: '[笑]', path: 'assets/images/emoji/笑.png'),
  EmojiItem(name: '[笑1]', path: 'assets/images/emoji/笑-1.png'),
];

String? getEmojiPath(String name) {
  try {
    return defaultEmojiList.firstWhere((e) => e.name == name).path;
  } catch (_) {
    return null;
  }
}
