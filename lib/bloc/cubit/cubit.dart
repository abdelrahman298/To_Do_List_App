import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/bloc/states/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_app/screens/archived.dart';
import 'package:to_do_list_app/screens/doneScreen.dart';
import 'package:to_do_list_app/screens/newTasksScreen.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitialState());
  static TasksCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  Database? database;
  List<Map> tasks = [];
  List<Map> newTasksScreen = [];
  List<Map> doneTasksScreen = [];
  List<Map> archivedTasksScreen = [];
  IconData? floatingIcon = Icons.add;
  bool isBottomSheetShown = false;

  void getCurrentIndex(int index) {
    currentIndex = index;
    emit(TasksChangeBottomNavBatState());
  }

  void bottomSheetIcon({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    floatingIcon = icon;
    emit(TasksBottomSheetIconState());
  }

  void createDatabase() {
    openDatabase('ToDo.db', version: 1, onCreate: ((database, version) {
      print('database has been created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table Database has been executed');
      }).catchError((error) {
        print('there is an error in databaseCreated $error');
      });
    }), onOpen: (database) {
      print('data has been opened');
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(TasksCreateDatabaseState());
    });
  }

  void getDataFromDatabase(database) {
    newTasksScreen = [];
    doneTasksScreen = [];
    archivedTasksScreen = [];
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasksScreen.add(element);
        } else if (element['status'] == 'done') {
          doneTasksScreen.add(element);
        } else if (element['status'] == 'archived') {
          archivedTasksScreen.add(element);
        }
      });
      tasks = value;
      print(tasks);
      emit(TasksGetDatabaseBatState());
    });
  }

  Future insertDatabase(
      {required String title,
      required String date,
      required String time,
      required BuildContext context}) async {
    return await database!.transaction((txn) async {
      txn
          .rawInsert('INSERT INTO tasks(title,date,time,status)'
              'VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted Successfully');
      }).catchError((error) {
        print(error);
      });
    }).then((value) {
      getDataFromDatabase(database);
      Navigator.pop(context);
      emit(TasksInsertDatabaseState());
    });
    return null;
  }

  void updateDatabase({required int id, required String status}) {
    database!.rawUpdate(
        'UPDATE tasks SET  status= ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      print(tasks);
      emit(TasksUpdateDatabaseState());
    });
  }

  void deleteDatabase({required int id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      print(id);
      getDataFromDatabase(database);
      emit(TasksDeleteDatabaseState());
    });
  }
}
