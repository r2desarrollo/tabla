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
      title: 'Syncfusion DataGrid Demo',
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
        'http://192.168.1.110:5001/api/pesaje'));
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
        width: 100,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            '',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'freight',
        width: 70,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text('Freight'),
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
        title: Text('Flutter DataGrid Sample'),
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
        reporte: json['reporte'],
);

  }

  _Product(
      {this.id,
        this.material,
         this.pesoneto,
         this.evidencia,
         this.sucursal,
         this.proveedor,
         this.materialNavigation,
        this.proveedorNavigation,
        this.sucursalNavigation,
        this.reporte
      });
  int id;
    int material;
    int pesoneto;
    String evidencia;
    int sucursal;
    int proveedor;
    dynamic materialNavigation;
    dynamic proveedorNavigation;
    dynamic sucursalNavigation;
    List<dynamic> reporte;
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
        DataGridCell<int>(columnName: 'Proveedor', value: dataGridRow.id),
        DataGridCell<String>(
            columnName: 'Material', value: dataGridRow.evidencia),
        DataGridCell<int>(
            columnName: 'Peso', value: dataGridRow.id),
        DataGridCell<int>(
            columnName: '', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'freight', value: dataGridRow.evidencia),
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
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}
