import 'package:flutter/material.dart';
import 'package:visualizador_charts/display/routes/routes.dart';
import 'package:visualizador_charts/display/ui/screens/pagina_principal.dart';
import 'package:visualizador_charts/display/ui/screens/pantalla_grafico_barras.dart';
import 'package:visualizador_charts/display/ui/screens/pantalla_grafico_lineas.dart';
import 'package:visualizador_charts/display/ui/screens/pantalla_grafico_pies.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.home: (_) => const PaginaPrincipal(),
        Routes.graficoBarras: (_) => const PantallaGraficoBarras(),
        Routes.graficoLineas: (_) => const PantallaGraficoLineas(),
        Routes.graficoPies: (_) => const PantallaGraficoPies(),
      },
      initialRoute: Routes.home,
    );
  }
}
