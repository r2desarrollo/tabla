import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tickets',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: JsonDataGrid(),
    );
  }
}

class JsonDataGrid extends StatefulWidget {
  @override
  _JsonDataGridState createState() => _JsonDataGridState();
}

class _JsonDataGridState extends State<JsonDataGrid> {
   _JsonDataGridSource jsonDataGridSource;
  List<_Product> productlist = [];

  Future generateProductList() async {
    var response = await http.get(Uri.parse(
        'http://192.168.1.71:5001/api/pesaje'));
    var list = json.decode(response.body).cast<Map<String, dynamic>>();
    productlist =
        await list.map<_Product>((json) => _Product.fromJson(json)).toList();
    jsonDataGridSource = _JsonDataGridSource(productlist);
    return productlist;
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridColumn(
        columnName: 'Proveedor',
        width: 70,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Proveedor',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Material',
        width: 95,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            'Material',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Peso',
        width: 95,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Peso',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),

      GridColumn(
        columnName: '',
        width: 70,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(''),
        ),
      )
    ]);
    return columns;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TICKETS'),
        centerTitle: true,

      ),
      body: Container(
          child: FutureBuilder(
              future: generateProductList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? SfDataGrid(
                        source: jsonDataGridSource, columns: getColumns())
                    : Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      );
              })),
    );
  }
}

class _Product {
  factory _Product.fromJson(Map<String, dynamic> json) {
    return _Product(
        id: json['id'] ?? "",
        material: json['material'],
        pesoneto: json['pesoneto'],
        evidencia: json['evidencia'],
        sucursal: json['sucursal'],
        proveedor: json['proveedor'],
);

  }

  _Product(
      {this.id,
        this.material,
         this.pesoneto,
         this.evidencia,
         this.sucursal,
         this.proveedor,
      });

    int id;
    String material;
    int pesoneto;
    String evidencia;
    String sucursal;
    String proveedor;

}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource(this.productlist) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<_Product> productlist = [];

  void buildDataGridRow() {
    dataGridRows = productlist.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Proveedor', value: dataGridRow.proveedor),
        DataGridCell<String>(
            columnName: 'Material', value: dataGridRow.material),
        DataGridCell<int>(
            columnName: 'Peso', value: dataGridRow.pesoneto),
        DataGridCell<String>(columnName: '', value: dataGridRow.evidencia),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
   Widget _bottonPhoto() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 23, 182, 103),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
      );
      return ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        },
        child: const Icon(Icons.add_a_photo),
      );
    });
  }
}
