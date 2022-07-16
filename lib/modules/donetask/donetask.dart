import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/shared/component/components.dart';
import 'package:new_app/shared/component/constants.dart';
import 'package:new_app/shared/cubit/cubit.dart';
import 'package:new_app/shared/cubit/states.dart';

class Donetask extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit.get(context).doneTasks;
    return tasksBuilder(tasks: tasks);
  }
}
