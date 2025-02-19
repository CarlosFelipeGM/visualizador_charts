import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_charts/data/models/pie_model.dart';
import 'package:visualizador_charts/data/repositories/pie_repository.dart';
import 'package:visualizador_charts/display/ui/components/input_grafico.dart';
import 'package:visualizador_charts/display/ui/utils/utils.dart';

class PantallaGraficoPies extends StatefulWidget {
  const PantallaGraficoPies({super.key});

  @override
  State<PantallaGraficoPies> createState() => _PantallaGraficoPiesState();
}

class _PantallaGraficoPiesState extends State<PantallaGraficoPies> {
  final _etiquetaTextEditingController = TextEditingController();
  final _valorTextEditingController = TextEditingController();
  final _idFormulario = GlobalKey<FormState>();

  PieModel? _pieModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pieModel = pieRepository.obtenerDatosTajadas();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pieModel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de pies'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      direction: TooltipDirection.bottom,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(_pieModel!.etiqueta[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  pieGroups: _pieModel!.valor.asMap().entries.map((elemento) {
                    return PieChartGroupData(
                      x: elemento.key,
                      barRods: [
                        PieChartRodData(
                            toY: elemento.value, color: Colors.blue),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Form(
            key: _idFormulario,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                children: [
                  InputGrafico(
                    controller: _etiquetaTextEditingController,
                    label: 'Etiqueta',
                    autocorrect: false,
                    textInputType: TextInputType.text,
                    validator: (valor) {
                      return ValidacionDeData.validarCampoObligatorio(valor);
                    },
                  ),
                  InputGrafico(
                    controller: _valorTextEditingController,
                    label: 'Valor',
                    autocorrect: false,
                    textInputType: TextInputType.number,
                    validator: (valor) {
                      return ValidacionDeData.validarNumero(valor);
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final esValiado = _idFormulario.currentState?.validate();
                      final pieModel = _pieModel;

                      if (esValiado == true && pieModel != null) {
                        setState(() {
                          pieModel.etiqueta
                              .add(_etiquetaTextEditingController.text);
                          pieModel.valor.add(
                              double.parse(_valorTextEditingController.text));
                        });

                        pieRepository.guardarTajadasDatos(pieModel);
                      }
                    },
                    label: const Text('Agregar'),
                    icon: Icon(Icons.add),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Alertas.mostrarAlertaDeConfirmacion(context,
                          alBorrar: (ctx) {
                        final pieModel = _pieModel;
                        if (pieModel != null) {
                          setState(() {
                            pieModel.etiqueta.removeLast();
                            pieModel.valor.removeLast();
                          });

                          pieRepository.guardarTajadasDatos(pieModel);

                          Navigator.pop(ctx);
                        }
                      });
                    },
                    label: const Text('Borrar último'),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _etiquetaTextEditingController.dispose();
    _valorTextEditingController.dispose();
  }
}
