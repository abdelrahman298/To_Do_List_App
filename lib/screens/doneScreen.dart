import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/bloc/cubit/cubit.dart';
import 'package:to_do_list_app/modules/defaultFormField.dart';
import 'package:to_do_list_app/modules/constant.dart';
import 'package:to_do_list_app/bloc/cubit/cubit.dart';
import 'package:to_do_list_app/bloc/states/states.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksStates>(
        listener: (context, states) => {},
        builder: (context, states) {
          var tasks = TasksCubit.get(context).doneTasksScreen;
          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) => tasks.length > 0,
            widgetBuilder: (BuildContext context) => ListView.separated(
                itemBuilder: (buildContext, index) {
                  return buildTaskItem(tasks[index], context);
                },
                separatorBuilder: (buildContext, int) {
                  return Container(
                    height: .5,
                    color: Colors.grey,
                  );
                },
                itemCount: tasks.length),
            fallbackBuilder: (BuildContext context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 90,
                  color: Colors.grey,
                ),
                Text(
                  'No tasks added yet,Please add yours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
          );
        });
  }
}
