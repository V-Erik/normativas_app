import 'package:flutter/material.dart';

import '../data/glosario.dart';
import '../theme/app_theme.dart';

/// Pantalla del glosario.
///
/// CÓMO SE USA ESTO DE VERDAD
/// --------------------------
/// Nadie lee un glosario de corrido. Se llega aquí con una palabra
/// concreta en la cabeza, se busca, se lee y se vuelve. Todo el diseño
/// de la pantalla sale de esa única suposición:
///
///   · El buscador está arriba del todo y recibe el foco solo si el
///     usuario lo toca, no al entrar: abrir la pantalla y que salte el
///     teclado tapando media lista es molesto cuando lo que quieres es
///     mirar qué hay.
///   · Las tarjetas vienen plegadas. Así caben unas ocho en pantalla y
///     se puede barrer con la vista; se despliega solo la que interesa.
///   · La búsqueda ignora tildes, porque en el teclado del teléfono
///     nadie las escribe con prisa.
///
/// LOS FILTROS NO SON DECORACIÓN
/// -----------------------------
/// Sirven para el otro modo de uso: el estudiante que está en la lección
/// de seguridad y quiere ver de golpe el vocabulario de esa norma. Por
/// eso el filtro y el buscador se combinan en vez de excluirse.
class GlosarioScreen extends StatefulWidget {
  const GlosarioScreen({super.key, this.categoriaInicial});

  /// Permite abrir la pantalla ya filtrada, por ejemplo desde una lección
  /// de seguridad. Si es null, se muestra todo.
  final CategoriaGlosario? categoriaInicial;

  @override
  State<GlosarioScreen> createState() => _GlosarioScreenState();
}

class _GlosarioScreenState extends State<GlosarioScreen> {
  final TextEditingController _controlador = TextEditingController();

  String _consulta = '';
  CategoriaGlosario? _categoria;

  @override
  void initState() {
    super.initState();
    _categoria = widget.categoriaInicial;
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  /// Primero la búsqueda (que además ordena por relevancia) y después el
  /// filtro. En este orden el orden por relevancia se conserva.
  List<TerminoGlosario> get _resultados {
    var lista = Glosario.buscar(_consulta);
    if (_categoria != null) {
      lista = lista.where((t) => t.categoria == _categoria).toList();
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Glosario'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          _buscador(),
          _filtros(),
          _contador(resultados.length),
          Expanded(
            child: resultados.isEmpty
                ? _vacio()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    itemCount: resultados.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        _TarjetaTermino(termino: resultados[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buscador() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: TextField(
        controller: _controlador,
        textInputAction: TextInputAction.search,
        onChanged: (v) => setState(() => _consulta = v),
        decoration: InputDecoration(
          hintText: 'Buscar un término o una norma',
          prefixIcon: const Icon(Icons.search, size: 22),
          suffixIcon: _consulta.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: 'Limpiar',
                  onPressed: () {
                    _controlador.clear();
                    setState(() => _consulta = '');
                  },
                ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true,
          fillColor: const Color(0xFFF4F6FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _filtros() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _chip(
              etiqueta: 'Todo',
              activo: _categoria == null,
              color: AppColors.deepPurple,
              alPulsar: () => setState(() => _categoria = null),
            ),
            for (final c in CategoriaGlosario.values) ...[
              const SizedBox(width: 8),
              _chip(
                etiqueta: c.etiqueta,
                activo: _categoria == c,
                color: colorDeCategoria(c),
                alPulsar: () => setState(
                  // Volver a pulsar el filtro activo lo quita. Es lo que
                  // la gente intenta hacer por instinto.
                  () => _categoria = _categoria == c ? null : c,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required String etiqueta,
    required bool activo,
    required Color color,
    required VoidCallback alPulsar,
  }) {
    return Material(
      color: activo ? color : const Color(0xFFF4F6FB),
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        onTap: alPulsar,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            etiqueta,
            style: TextStyle(
              fontSize: 13,
              fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
              color: activo ? Colors.white : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _contador(int n) {
    final texto = n == 1 ? '1 término' : '$n términos';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget _vacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 44, color: AppColors.textGrey),
            const SizedBox(height: 14),
            Text(
              'No hay ningún término que coincida con «$_consulta».',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
            const SizedBox(height: 6),
            const Text(
              'Prueba con una palabra más corta o con las siglas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Color por categoría.
///
/// Se define aquí y no en el tema porque solo lo usa el glosario, y
/// meterlo en `app_theme.dart` obligaría a tocar un archivo compartido
/// para una pantalla nueva.
Color colorDeCategoria(CategoriaGlosario c) {
  switch (c) {
    case CategoriaGlosario.calidad:
      return AppColors.deepPurple;
    case CategoriaGlosario.seguridad:
      return const Color(0xFFD1495B);
    case CategoriaGlosario.cicloVida:
      return const Color(0xFF3B6FD4);
    case CategoriaGlosario.requisitos:
      return const Color(0xFFB8860B);
    case CategoriaGlosario.pruebas:
      return AppColors.primaryGreen;
    case CategoriaGlosario.agil:
      return const Color(0xFF0E7C86);
  }
}

class _TarjetaTermino extends StatelessWidget {
  const _TarjetaTermino({required this.termino});

  final TerminoGlosario termino;

  @override
  Widget build(BuildContext context) {
    final color = colorDeCategoria(termino.categoria);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // ExpansionTile pinta divisores propios que chocan con el borde
        // de la tarjeta.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: color,
          collapsedIconColor: AppColors.textGrey,
          title: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  termino.sigla == null
                      ? termino.termino
                      : '${termino.termino}  ·  ${termino.sigla}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 14, top: 2),
            child: Text(
              termino.norma ?? termino.categoria.etiqueta,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          children: [
            Text(
              termino.definicion,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
            if (termino.enLaPractica != null) ...[
              const SizedBox(height: 14),
              // El filete de color va como hijo y no como `Border(left:)`:
              // un borde no uniforme combinado con `borderRadius` hace
              // saltar una aserción de BoxDecoration en tiempo de
              // ejecución.
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                clipBehavior: Clip.antiAlias,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: 3, color: color),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(11, 11, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EN LA PRÁCTICA',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                termino.enLaPractica!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
