import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/modules/archivedtasks/archivedtask.dart';
import 'package:new_app/modules/donetask/donetask.dart';
import 'package:new_app/modules/newtask/newtask.dart';
import 'package:new_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<Appstates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentindex = 0;
  List<Widget> screens = [
    NewTask(),
    Donetask(),
    ArchivedTask(),
  ];
  List<String> title = [
    'New Task',
    'Done Tasks',
    'Archived Tasks',
  ];
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomSheetShow = false;

  IconData fab = Icons.edit;

  void changeIndex(int index) {
    currentindex = index;
    emit(AppchangeBottomNavBarState());
  }


  void creatdb() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('DataBase created');
        database.execute(
            'create TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error when created table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getdb(database);
        print('DataBase Opened');
       // print(newTasks);
        //print('*');
        //print(doneTasks);
        //print('+');
        //print(archiveTasks);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDB());
    });
  }

  insertdb({
    @required String title,
    @required String time,
    @required String date,
  }) async
  {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks ( title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value INSERT successfully');
        emit(AppInsertDB());
        getdb(database);
      }).catchError((error) {
        print('Error when Inserting NEw record ${error.toString()}');
      });
      return null;
    });
  }

  void getdb(database) {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];

    emit(AppGetDBloadingstate());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
       if( element['status'] =='new')
         newTasks.add(element);
       else if( element['status'] =='done')
         doneTasks.add(element);
       else if( element['status'] =='archive')
         archiveTasks.add(element);
      });
      emit(AppGetDB());
    });
  }


  void changeBottomsheet({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fab = icon;
    emit(AppchangeBottomSheetState());
  }

  void updateDB({
    @required String status,
    @required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getdb(database);
      emit(AppUpdateDB());
    });
  }
  void deletDB({
    @required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getdb(database);
      emit(AppDeleteDB());
    });
  }
}
