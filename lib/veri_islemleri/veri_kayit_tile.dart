import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class veri_kayit_tile extends StatelessWidget {
  final String baslikName;
  final bool baslikCheck;
  final Function(bool?)? onChanged;

  const veri_kayit_tile({super.key,
  required this.baslikName,
  required this.baslikCheck,
  required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[100], 
        
        ),
        child: Row(
          children: [
            Checkbox(value: baslikCheck, onChanged: onChanged),
            Text(baslikName)
          ],
        ),
        
      ),
    );
  }
}