import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/modules/constant.dart';
import 'package:to_do_list_app/bloc/cubit/cubit.dart';

Widget defaultFormField({
  required TextInputType type,
  required TextEditingController? controller,
  required String labelText,
  required IconData iconForm,
  Function()? onTap,
  Function(String)? onChanged,
  String? Function(String?)? validate,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      autofocus: false,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 18),
        prefixIcon: Icon(iconForm),
      ),
      onTap: onTap,
      validator: validate,
      onChanged: onChanged,
    );

Widget buildTaskItem(Map modal, context) => Dismissible(
      key: Key(modal['id'].toString()),
      onDismissed: (direction) {
        TasksCubit.get(context).deleteDatabase(id: modal['id']);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text("${modal['time']}"),
            ),
            // SizedBox(width: 10),
            Container(
              child: Column(
                children: [
                  Text(
                    "${modal['title']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${modal['date']}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () {
                      TasksCubit.get(context)
                          .updateDatabase(id: modal['id'], status: 'done');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.archive_outlined),
                    onPressed: () {
                      TasksCubit.get(context)
                          .updateDatabase(id: modal['id'], status: 'archived');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
