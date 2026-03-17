import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/discover/main/bloc/bloc.dart';
import 'package:beaver/features/discover/main/bloc/event.dart';
import 'package:beaver/features/discover/main/bloc/state.dart';
import 'package:beaver/features/discover/main/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class DiscoverMainPage extends StatefulWidget {
  const DiscoverMainPage({super.key});

  @override
  State<DiscoverMainPage> createState() => _DiscoverMainPageState();
}

class _DiscoverMainPageState extends State<DiscoverMainPage> {
  late DiscoverBloc _discoverBloc;

  @override
  void initState() {
    super.initState();
    _discoverBloc = DiscoverBloc(DiscoverMainRepository())..add(LoadDiscoverItemsEvent());
  }

  @override
  void dispose() {
    _discoverBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _discoverBloc,
      child: BlocConsumer<DiscoverBloc, DiscoverState>(
        listener: (context, state) {
          if (state.status == DiscoverStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '发现',
            showBack: false,
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.w,
              ),
              itemCount: state.discoverItems.length,
              itemBuilder: (context, index) {
                final item = state.discoverItems[index];
                return _buildDiscoverItem(item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscoverItem(dynamic item) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 32.w, color: Colors.orange),
            SizedBox(height: 8.w),
            Text(item.title),
          ],
        ),
      ),
    );
  }
}
