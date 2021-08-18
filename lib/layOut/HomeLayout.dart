import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/modules/constant.dart';
import 'package:to_do_list_app/modules/defaultFormField.dart';
import 'package:to_do_list_app/screens/newTasksScreen.dart';
import 'package:to_do_list_app/screens/doneScreen.dart';
import 'package:to_do_list_app/screens/archived.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:to_do_list_app/bloc/cubit/cubit.dart';
import 'package:to_do_list_app/bloc/states/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var textController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TasksCubit()..createDatabase(),
      child: BlocConsumer<TasksCubit, TasksStates>(
        listener: (BuildContext context, TasksStates state) {},
        builder: (BuildContext context, TasksStates state) {
          TasksCubit cubit = TasksCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            body: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) =>
                  cubit.tasks.length > 0,
              widgetBuilder: (BuildContext context) =>
                  cubit.screens[cubit.currentIndex],
              fallbackBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                cubit.floatingIcon,
                size: 30,
              ),
              onPressed: () {
                if (cubit.isBottomSheetShown == false) {
                  cubit.bottomSheetIcon(isShow: true, icon: Icons.edit);
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                    type: TextInputType.text,
                                    controller: textController,
                                    iconForm: Icons.task_alt_outlined,
                                    labelText: 'Add your text',
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task must be written';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      textController.text = value;
                                    }),
                                SizedBox(height: 15),
                                defaultFormField(
                                  type: TextInputType.datetime,

                                  //when tapping on it show the time picker
                                  //so add onTap pressed
                                  controller: dateController,
                                  iconForm: Icons.calendar_today_rounded,
                                  labelText: 'Add your date',
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must be insert';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate:
                                          DateTime(DateTime.now().year + 5),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(dateController.text);
                                    }).catchError(
                                      (onError) {
                                        print(
                                            'there is an error in datePicker called $onError');
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 15),
                                defaultFormField(
                                  type: TextInputType.datetime,
                                  controller: timeController,
                                  iconForm: Icons.timer,
                                  labelText: 'Add your Time',
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must be insert';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context);
                                    }).catchError((onError) {
                                      print(
                                          'there is an error in timePicker called $onError');
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.bottomSheetIcon(isShow: false, icon: Icons.add);
                  });
                } else {
                  if (cubit.isBottomSheetShown == true) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertDatabase(
                        title: textController.text,
                        date: dateController.text,
                        time: timeController.text,
                        context: context,
                      );
                    }
                  }
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.getCurrentIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_task_rounded),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived Tasks',
                ),
              ],
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        },
      ),
    );
  }
}
