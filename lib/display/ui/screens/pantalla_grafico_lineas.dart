import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_charts/data/models/line_model.dart';
import 'package:visualizador_charts/data/repositories/line_repository.dart';
import 'package:visualizador_charts/display/ui/components/input_grafico.dart';
import 'package:visualizador_charts/display/ui/utils/utils.dart';

class PantallaGraficoLineas extends StatefulWidget {
  const PantallaGraficoLineas({super.key});

  @override
  State<PantallaGraficoLineas> createState() => _PantallaGraficoLineasState();
}

class _PantallaGraficoLineasState extends State<PantallaGraficoLineas> {
  final _identificadorFormulario = GlobalKey<FormState>();
  final _xCoordTextController = TextEditingController();
  final _yCoordTextController = TextEditingController();

  LineModel? _lineModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      _lineModel = lineRepository.obtenerDatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lineModel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Lineas'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.blue,
                    spots: _lineModel!.ejeX.asMap().entries.map(
                      (valor) {
                        return FlSpot(valor.value, _lineModel!.ejeY[valor.key]);
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
          Form(
            key: _identificadorFormulario,
            child: Column(
              spacing: 8,
              children: [
                InputGrafico(
                  label: 'Valor en X',
                  autocorrect: false,
                  textInputType: TextInputType.number,
                  controller: _xCoordTextController,
                  validator: (valor) {
                    return ValidacionDeData.validarNumero(valor);
                  },
                ),
                InputGrafico(
                  label: 'Valor en Y',
                  autocorrect: false,
                  textInputType: TextInputType.number,
                  controller: _yCoordTextController,
                  validator: (valor) {
                    return ValidacionDeData.validarNumero(valor);
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final esValido =
                        _identificadorFormulario.currentState?.validate();
                    final lineModel = _lineModel;
                    if (esValido == true && lineModel != null) {
                      setState(() {
                        lineModel.ejeX
                            .add(double.parse(_xCoordTextController.text));
                        lineModel.ejeY
                            .add(double.parse(_yCoordTextController.text));
                      });

                      lineRepository.guardarPuntosDatos(lineModel);
                    }
                  },
                  label: const Text('Agregar'),
                  icon: Icon(Icons.add),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Alertas.mostrarAlertaDeConfirmacion(context,
                        alBorrar: (ctx) {
                      final lineModel = _lineModel;
                      if (lineModel != null) {
                        setState(() {
                          lineModel.ejeX.removeLast();
                          lineModel.ejeY.removeLast();
                        });

                        lineRepository.guardarPuntosDatos(lineModel);

                        Navigator.pop(ctx);
                      }
                    });
                  },
                  label: const Text('Borrar último'),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _xCoordTextController.dispose();
    _yCoordTextController.dispose();
  }
}
