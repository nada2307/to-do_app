import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/shared/cubit/cubit.dart';

Widget defultbutton({
  double width=double.infinity,
  Color background= Colors.blue,
  bool isUpperCase = true,
  @required Function function,
  @required String text,

})=>  Container(
  color: background,
  width: width,
  child: MaterialButton(
    onPressed: function,
    child:Text(
        isUpperCase? text.toUpperCase(): text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);

Widget defultformfield({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function ontab,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  bool isPassword = false,
  //IconButton iconb,
  Function onpress,
  Icon suffix,
}) => TextFormField(
  controller: controller,
   decoration: InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
       color: Colors.purpleAccent  ,
    ),
    focusColor: Colors.purpleAccent,
    // fillColor: Colors.purpleAccent,
     focusedBorder: OutlineInputBorder(
         borderSide: BorderSide(
             color: Colors.purpleAccent
         ),
     ),
    border: OutlineInputBorder(),
    prefixIcon: Icon(
        prefix,
     color: Colors.purpleAccent,
    ),
    suffixIcon: suffix!= null ?  IconButton(

      onPressed: onpress ,
      icon: suffix,
    ) : null,
  ),
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onTap: ontab,
  onChanged: onChange,
  validator: validate,
);

Widget buildTaskItem(Map model , context ) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [

        CircleAvatar(
          backgroundColor: Colors.purpleAccent,
          radius: 37.0,

          child: Text(

            '${model['time']}',

            style: TextStyle(

              color: Colors.white,

              fontWeight: FontWeight.bold,

            ),

          ),

        ),

        SizedBox(

          width: 15.0,

        ),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 20.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              SizedBox(

                height: 10.0,

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  color: Colors.grey,

                  fontSize: 15.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 7.0,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateDB(status: 'done', id: model['id']);


            },

            icon: Icon(

              Icons.check_box_rounded,

              color: Colors.greenAccent,

            )

        ),

        SizedBox(

          width: 7.0,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateDB(status: 'archive', id: model['id']);

            },

            icon: Icon(

              Icons.archive,

              color: Colors.black45,

            )

        ),

      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).deletDB(id: model['id'],);
  },
);

Widget tasksBuilder({
  @required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) =>
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
          ),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks yet, please add some tasks',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize:15.0,
          ),
        ),
      ],
    ),
  ),
);