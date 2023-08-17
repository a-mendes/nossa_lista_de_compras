import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/lista_de_compras.dart';

class DropdownMenuCustom<T> extends StatefulWidget {
  final List<T> list;
  final Function(T)? doOnSelected;

  const DropdownMenuCustom({
    Key? key,
    required this.list,
    required this.doOnSelected,
  }) : super(key: key);

  @override
  State<DropdownMenuCustom<T>> createState() => _DropdownMenuCustomState<T>();
}

class _DropdownMenuCustomState<T> extends State<DropdownMenuCustom<T>> {
  late T dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: dropdownValue,
      onChanged: (T? value) {
        setState(() {
          dropdownValue = value!;
        });

        if (widget.doOnSelected != null) {
          widget.doOnSelected!(value!);
        }
      },
      items: widget.list.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}