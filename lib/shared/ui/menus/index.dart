import 'package:flutter/material.dart';

class BeaverMenus extends StatelessWidget {
  final List<MenuItem> items;
  final VoidCallback? onClose;
  final bool showCloseButton;

  const BeaverMenus({
    super.key,
    required this.items,
    this.onClose,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCloseButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ...items.map((item) => _buildMenuItem(item)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            if (item.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: item.icon!,
              ),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (item.trailing != null)
              item.trailing!,
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  MenuItem({
    required this.title,
    this.icon,
    this.trailing,
    this.onTap,
  });
}
