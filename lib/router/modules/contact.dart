import 'package:go_router/go_router.dart';
import 'package:beaver/features/contact/list/list.dart';
import 'package:beaver/features/contact/detail/detail.dart';
import 'package:beaver/features/contact/new_friends/new_friends.dart';
import 'package:beaver/features/contact/search/search.dart';
import 'package:beaver/features/contact/add/add.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> contactRoutes() {
  return [
    GoRoute(
      path: AppRoutes.contactList,
      builder: (context, state) => const ContactListPage(),
    ),
    GoRoute(
      path: AppRoutes.contactDetail,
      builder: (context, state) => const ContactDetailPage(),
    ),
    GoRoute(
      path: AppRoutes.addContact,
      builder: (context, state) => const AddContactPage(),
    ),
    GoRoute(
      path: AppRoutes.searchContact,
      builder: (context, state) => const SearchContactPage(),
    ),
    GoRoute(
      path: AppRoutes.newFriends,
      builder: (context, state) => const NewFriendsPage(),
    ),
  ];
}
