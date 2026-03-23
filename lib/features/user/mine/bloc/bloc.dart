import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/mine/bloc/event.dart';
import 'package:beaver/features/user/mine/bloc/state.dart';

class MineBloc extends Bloc<MineEvent, MineState> {
  MineBloc() : super(const MineState()) {
    // Other events for Mine page can be added here
  }
}

