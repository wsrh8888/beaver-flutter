import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/guide/main/bloc/bloc.dart';
import 'package:beaver/features/guide/main/bloc/event.dart';
import 'package:beaver/features/guide/main/bloc/state.dart';
import 'package:beaver/features/guide/main/data/repositories/repository.dart';

class GuideMainPage extends StatefulWidget {
  const GuideMainPage({super.key});

  @override
  State<GuideMainPage> createState() => _GuideMainPageState();
}

class _GuideMainPageState extends State<GuideMainPage> {
  late GuideBloc _guideBloc;

  @override
  void initState() {
    super.initState();
    _guideBloc = GuideBloc(GuideRepository())..add(LoadGuideConfigEvent());
  }

  @override
  void dispose() {
    _guideBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _guideBloc,
      child: BlocConsumer<GuideBloc, GuideState>(
        listener: (context, state) {
          if (state.status == GuideStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Text('Welcome to Beaver', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                   SizedBox(height: 40.h),
                   ElevatedButton(onPressed: () {}, child: const Text('Login')),
                   SizedBox(height: 16.h),
                   OutlinedButton(onPressed: () {}, child: const Text('Register')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
