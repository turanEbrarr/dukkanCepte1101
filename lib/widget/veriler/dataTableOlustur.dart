import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class dataTableOlustur extends StatefulWidget {
  const dataTableOlustur({super.key, required this.satirlar, required this.kolonlar,genislik=20,siralanacakIndex=0});
  final List<DataRow> satirlar;
  final List<DataColumn> kolonlar;
  final double? genislik =20;
  final int siralanacakIndex = 0;


  @override
  State<dataTableOlustur> createState() => _dataTableOlusturState();
}

class _dataTableOlusturState extends State<dataTableOlustur> {
     List<Color> rowColors = [
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 174, 179, 176),
    ];

    int _currentColorIndex = 0;
       Color getNextRowColor() {
      Color color = rowColors[_currentColorIndex];
      _currentColorIndex = (_currentColorIndex + 1) % rowColors.length;
      return color;
    }
       List<DataColumn> guncellenmisKolon = [];
       @override
  void initState() {
    // TODO: implement initState
    super.initState();
        for (var element in widget.kolonlar) {
      if ((element.label as Text).data == "Id") {
        guncellenmisKolon.add(DataColumn(
            label: SizedBox(
          width: 0,
          child: Text("Id"),
        )));
      } else {
        guncellenmisKolon.add(DataColumn(
          numeric: true,
              onSort: (columnIndex, _) {
          setState(() {
          
            
      
          
           
          });
        },
            label: SizedBox(
          width: 100,
          child: Text((element.label as Text).data!),
        )));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) {
                    return Color.fromARGB(255, 224, 241, 255);
                  }),
                  dataRowColor: MaterialStateColor.resolveWith((states) {
                    return getNextRowColor();
                  }),
                  columnSpacing: widget.genislik,
                  dataRowHeight: 50,
                  headingRowHeight: 40,
                  horizontalMargin: 16,
                 // sortAscending: true,
                //  sortColumnIndex: 2,
             
                  
                  columns: guncellenmisKolon,
                  rows: widget.satirlar),
            ),
          ),
        ),
      ),
    );;
  }
}