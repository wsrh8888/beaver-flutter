import 'package:go_router/go_router.dart';
import 'package:beaver/features/contact/contact_list/contact_list.dart';


class ContactRoutes {
  static const String contactList = '/contact/list';
  static const String contactDetail = '/contact/:userId';
  static const String addContact = '/contact/add';
  static const String searchContact = '/contact/search';
}

List<GoRoute> contactRoutes = [
  GoRoute(
    path: ContactRoutes.contactList,
    builder: (context, state) => const ContactListPage(),
  ),
  // 可以在这里添加更多联系人相关路由
];

