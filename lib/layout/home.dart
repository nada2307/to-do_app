import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_app/modules/archivedtasks/archivedtask.dart';
import 'package:new_app/modules/donetask/donetask.dart';
import 'package:new_app/modules/newtask/newtask.dart';
import 'package:new_app/shared/component/components.dart';
import 'package:new_app/shared/component/constants.dart';
import 'package:new_app/shared/cubit/cubit.dart';
import 'package:new_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatelessWidget {

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var titelecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //AppCubit cubit = AppCubit.get(context);
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatdb(),
      child: BlocConsumer<AppCubit, Appstates>(
        listener: (BuildContext context, Appstates state) {
          if(state is AppInsertDB){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, Appstates state) {
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.purpleAccent ,
              title: Text(
                AppCubit
                    .get(context)
                    .title[AppCubit
                    .get(context)
                    .currentindex],

              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDBloadingstate,
              builder: (context) =>
              AppCubit.get(context).screens[AppCubit.get(context).currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.purpleAccent,
              onPressed: () {
                if ( AppCubit.get(context).isBottomSheetShow) {
                  if (formkey.currentState.validate()) {
                    AppCubit.get(context).insertdb(
                        title: titelecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text
                    );
                  }
                }
                else {
                  scaffoldkey.currentState.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(primaryColor: Colors.purpleAccent ),
                                    child: defultformfield(
                                      controller: titelecontroller,
                                      type: TextInputType.text,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return 'Title must not be empty';
                                        }
                                        return null;
                                      },
                                      label: 'Task Title',
                                      prefix: Icons.task_alt_rounded,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),


                                  defultformfield(
                                    controller: timecontroller,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    ontab: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timecontroller.text =
                                            value.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    label: ' Time',
                                    prefix: Icons.watch_later_outlined,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defultformfield(
                                    controller: datecontroller,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    ontab: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2021-12-01'),
                                      ).then((value) {
                                        datecontroller.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    AppCubit.get(context).changeBottomsheet(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });
                  AppCubit.get(context).changeBottomsheet(
                      isShow: true,
                      icon: Icons.add
                  );
                }
              },
              child: Icon(
                AppCubit.get(context).fab,


              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              //backgroundColor: Colors.purpleAccent,
              items: [
                BottomNavigationBarItem(
                  //backgroundColor: Colors.purpleAccent,
                  icon: Icon(
                    Icons.list_sharp,
                  ),
                  label: 'New Task',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline_rounded,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
              unselectedItemColor: Colors.black45,
              selectedItemColor: Colors.purpleAccent,
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentindex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}


