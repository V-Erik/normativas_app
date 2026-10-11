import 'package:flutter/material.dart';

import '../data/mapeo_lecciones.dart';
import '../models/SeccionSilabo.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/progreso_service.dart';
import '../services/usuario_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascota_avatar.dart';
import '../widgets/mascota_viva.dart';
import 'auth/login_screen.dart';
import 'consentimiento_screen.dart';

// ===========================================================================
// PALETA DE LA PANTALLA
//
// No se inventa una identidad nueva: se reutiliza la de la app (verde de
// acción, morado de normativas) y se añade solo lo que hacía falta para
// distinguir los tipos de respuesta del tutor.
// ===========================================================================

const _fondo = Color(0xFFF2F4F9);        // más frío que el gris general,
                                          // para que las burbujas blancas
                                          // se despeguen del fondo
const _bordeBurbuja = Color(0xFFE7EAF3);
const _textoFuerte = Color(0xFF2B2B3C);
const _textoSuave = Color(0xFF8A8AA0);

/// Verde del visor de la mascota. Se usa solo para el punto de "en línea":
/// el estado del tutor queda atado al personaje en vez de a un verde
/// genérico de sistema.
const _verdeVisor = Color(0xFF2BE600);

/// Respuesta sin documentación de respaldo.
const _arenaFondo = Color(0xFFFFF8E7);
const _arenaBorde = Color(0xFFF2E3BC);
const _arenaTexto = Color(0xFF8A6A1C);

/// Pregunta fuera del temario.
const _lilaFondo = Color(0xFFF3EFFF);
const _lilaBorde = Color(0xFFDFD3FF);
const _lilaTexto = Color(0xFF6A4BC4);

/// Problema del servidor.
const _rojoFondo = Color(0xFFFDECEC);
const _rojoBorde = Color(0xFFF7CFCF);
const _rojoTexto = Color(0xFFB03A3A);

// ===========================================================================
// MODELO LOCAL DE MENSAJE
//
// El ChatMessage del proyecto solo lleva texto y emisor. Aquí hace falta
// además el `tipo` que devuelve el backend, porque una respuesta normal,
// un "no está en mis documentos" y un "eso no es del temario" significan
// cosas distintas y deben verse distintas.
// ===========================================================================

class _Mensaje {
  final String texto;
  final bool esUsuario;

  /// respuesta | saludo | funcionamiento | sin_contexto | redireccion |
  /// sin_documentos | error | null (mensajes locales de la app)
  final String? tipo;

  /// "Esperaste 38 s en cola", cuando la espera fue notable.
  final String? nota;

  const _Mensaje.usuario(this.texto)
      : esUsuario = true,
        tipo = null,
        nota = null;

  const _Mensaje.tutor(this.texto, {this.tipo, this.nota}) : esUsuario = false;
}

/// Preguntas sugeridas del estado inicial.
///
/// Son cuatro a propósito, y todas del Mundo 2: son los únicos temas con
/// documentación indexada (ISO 9001, 25010, 27001 y 12207). Si alguien toca
/// una, el tutor responde con material real en lugar de decir que no lo
/// tiene. Para una demostración en vivo es la diferencia entre lucirse y
/// tener que explicar por qué no sabe.
const _sugerencias = <String>[
  '¿Qué es la ISO 9001?',
  '¿Qué características de calidad define la ISO 25010?',
  '¿Qué es un SGSI según la ISO 27001?',
  '¿Qué procesos cubre la ISO/IEC 12207?',
];

// ===========================================================================

/// Pantalla de Chat con el Tutor IA.
///
/// Modo libre: se abre sin [mundo]/[capitulo]/[leccion] (pestaña "Tutor IA").
/// Modo Ruta: se abre desde una lección y envía su `leccion_id`, para que el
/// tutor busque el contexto en el tema del sílabo de esa lección.
class ChatScreen extends StatefulWidget {
  final SeccionSilabo? mundo;
  final CapituloSilabo? capitulo;
  final LeccionSilabo? leccion;

  const ChatScreen({
    super.key,
    this.mundo,
    this.capitulo,
    this.leccion,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_Mensaje> _mensajes = [];

  bool _escribiendo = false;
  bool _leccionCompletada = false;

  /// Hilo de conversación: es la memoria del tutor. Vive en la RAM del
  /// servidor, así que se pierde si el servidor se reinicia.
  String? _conversacionId;

  /// Estado de la cola, mientras se espera turno.
  String? _avisoCola;

  /// Último mensaje que falló, para el botón de reintentar.
  String? _mensajePendiente;

  /// Aviso fijo bajo la cabecera.
  String? _avisoSuperior;

  /// Resumen del servidor para la cabecera.
  String _estadoServidor = '';
  bool _servidorListo = false;

  bool get _esModoRuta =>
      widget.mundo != null && widget.capitulo != null && widget.leccion != null;

  String? get _leccionIdBackend =>
      _esModoRuta ? MapeoLecciones.leccionIdParaChat(widget.leccion!.id) : null;

  Color get _acento => widget.mundo?.colorPrimario ?? AppColors.deepPurple;

  @override
  void initState() {
    super.initState();
    _arrancar();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ========================= ARRANQUE =========================

  /// Flujo recomendado por el backend:
  ///   1. sesión de Firebase (ya la hay si llegamos aquí)
  ///   2. GET /salud
  ///   3. GET /usuarios/yo -> consentimiento
  ///   4. POST /chat
  Future<void> _arrancar() async {
    try {
      final salud = await UsuarioService.salud();
      _servidorListo = salud.listo;
      if (mounted) {
        setState(() {
          // Sin subtítulo cuando todo va bien: la cabecera solo habla
          // cuando tiene algo que decir.
          _estadoServidor = salud.listo ? '' : 'Sin conexión con el tutor';
          if (!salud.listo) _avisoSuperior = salud.aviso;
        });
      }
    } on ErrorApi catch (e) {
      if (mounted) {
        setState(() {
          _estadoServidor = 'Sin conexión con el tutor';
          _avisoSuperior = e.mensaje;
        });
      }
    }

    if (!mounted) return;

    if (!_servidorListo) {
      setState(() {
        _mensajes.add(const _Mensaje.tutor(
          'Ahora mismo no puedo conectarme con el servidor, así que no '
          'puedo responder preguntas.\n\nLas lecciones y los ejercicios sí '
          'funcionan sin conexión: puedes seguir avanzando y volver aquí '
          'cuando el servidor esté encendido.',
          tipo: 'sin_documentos',
        ));
      });
      return;
    }

    // Consentimiento, antes de la primera pregunta, para no chocar con el 409.
    final usuario = AuthService.instance.usuario;
    if (usuario != null && !usuario.consentimientoAceptado) {
      final aceptado = await ConsentimientoScreen.abrir(context);
      if (!mounted) return;
      if (!aceptado) {
        setState(() {
          _mensajes.add(const _Mensaje.tutor(
            'Para usar el tutor necesito que aceptes el consentimiento '
            'informado. Cuando quieras, vuelve a entrar aquí.',
            tipo: 'sin_documentos',
          ));
        });
        return;
      }
    }

    if (!mounted) return;

    // Aviso honesto: 9 de los 27 temas del sílabo no tienen documento
    // indexado, y el tutor lo dirá. Mejor advertirlo antes que dejar que
    // parezca un fallo.
    if (_esModoRuta && MapeoLecciones.sinDocumentacion(widget.leccion!.id)) {
      setState(() {
        _avisoSuperior = 'De este tema todavía no hay documentación indexada: '
            'el tutor te dirá que no está en sus documentos en lugar de '
            'inventarse la norma.';
      });
    }

    if (_esModoRuta) {
      await _enviar(
        '${widget.capitulo!.nombre}: ${widget.leccion!.titulo}. '
        'Explícame de qué se trata.',
        mostrarComoUsuario: false,
      );
    }
    // En modo libre no se escribe nada: la pantalla de bienvenida con las
    // sugerencias es mejor punto de partida que un saludo en una burbuja.
  }

  // ========================= ENVÍO =========================

  void _alFinal() {
    // La lista va invertida: el final está en offset 0.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(0);
    });
  }

  Future<void> _enviar(String texto, {bool mostrarComoUsuario = true}) async {
    final mensaje = texto.trim();
    if (mensaje.isEmpty || _escribiendo) return;

    setState(() {
      if (mostrarComoUsuario) _mensajes.add(_Mensaje.usuario(mensaje));
      _escribiendo = true;
      _avisoCola = null;
      _mensajePendiente = null;
    });
    if (mostrarComoUsuario) _controller.clear();
    _alFinal();

    try {
      final r = await ChatService.preguntarAlTutor(
        mensaje,
        conversacionId: _conversacionId,
        leccionId: _leccionIdBackend,
        alCambiarCola: (estado) {
          if (mounted) setState(() => _avisoCola = estado.mensaje);
        },
      );

      if (!mounted) return;

      _conversacionId =
          r.conversacionId.isEmpty ? _conversacionId : r.conversacionId;

      setState(() {
        _mensajes.add(_Mensaje.tutor(r.respuesta, tipo: r.tipo, nota: r.notaDeEspera));
        _escribiendo = false;
        _avisoCola = null;
      });
      _alFinal();
    } on ErrorApi catch (e) {
      if (!mounted) return;
      setState(() {
        _escribiendo = false;
        _avisoCola = null;
      });
      await _manejarError(e, mensaje);
    }
  }

  /// 401 -> login. 409 -> consentimiento y reenviar. 503 y red -> reintentar
  /// a mano, nunca automático: reintentar solo alargaría la cola.
  Future<void> _manejarError(ErrorApi e, String mensaje) async {
    if (e.sesionCaducada) {
      await AuthService.instance.cerrarSesion();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
      return;
    }

    if (e.faltaConsentimiento) {
      final aceptado = await ConsentimientoScreen.abrir(context);
      if (!mounted) return;
      if (aceptado) {
        await _enviar(mensaje, mostrarComoUsuario: false);
        return;
      }
    }

    setState(() {
      _mensajes.add(_Mensaje.tutor(e.mensaje, tipo: 'error'));
      _mensajePendiente = mensaje;
    });
    _alFinal();
  }

  // ========================= LECCIÓN =========================

  Future<void> _terminarLeccion() async {
    if (!_esModoRuta || _leccionCompletada) return;

    final completada = await ProgresoService.instance.completarLeccion(
      widget.leccion!.id,
      widget.leccion!.experiencia,
    );

    if (!mounted) return;
    setState(() => _leccionCompletada = true);

    if (!completada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta lección ya estaba completada.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    // Lista invertida: el mensaje más nuevo va en el índice 0 y queda
    // pegado abajo. Es lo que hace cualquier app de mensajería, y evita
    // el hueco enorme que quedaba cuando había pocos mensajes.
    final visibles = _mensajes.reversed.toList();
    final vacio = _mensajes.isEmpty && !_escribiendo && !_esModoRuta;

    return Scaffold(
      backgroundColor: _fondo,
      appBar: _Cabecera(
        esModoRuta: _esModoRuta,
        acento: _acento,
        iconoMundo: widget.mundo?.icono,
        titulo: _esModoRuta
            ? 'Capítulo ${widget.capitulo!.numeroCapitulo}'
            : 'Tutor IA',
        subtitulo: _esModoRuta
            ? widget.leccion!.titulo
            : (_escribiendo ? 'Pensando…' : _estadoServidor),
        // el punto de estado solo aparece cuando hay subtítulo que marcar
        enLinea: _servidorListo,
        pensando: _escribiendo,
        mostrarTerminar: _esModoRuta && !_leccionCompletada,
        onTerminar: _escribiendo ? null : _terminarLeccion,
      ),
      body: Column(
        children: [
          if (_avisoSuperior != null)
            _Aviso(
              texto: _avisoSuperior!,
              onCerrar: () => setState(() => _avisoSuperior = null),
            ),
          Expanded(
            child: vacio
                ? _Bienvenida(
                    acento: _acento,
                    onSugerencia: (s) => _enviar(s),
                  )
                : ListView.builder(
                    controller: _scroll,
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    itemCount: visibles.length + (_escribiendo ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (_escribiendo && i == 0) {
                        return _Pensando(acento: _acento, aviso: _avisoCola);
                      }
                      final m = visibles[_escribiendo ? i - 1 : i];
                      return _Burbuja(mensaje: m, acento: _acento);
                    },
                  ),
          ),
          if (_leccionCompletada)
            _BarraLeccionCompletada(
              color: _acento,
              onVolver: () => Navigator.of(context).pop(),
            )
          else if (_mensajePendiente != null)
            _BarraReintentar(
              color: _acento,
              onReintentar: () {
                final m = _mensajePendiente!;
                setState(() => _mensajePendiente = null);
                _enviar(m, mostrarComoUsuario: false);
              },
              onDescartar: () => setState(() => _mensajePendiente = null),
            )
          else
            _BarraEscritura(
              controller: _controller,
              activo: !_escribiendo,
              onEnviar: () => _enviar(_controller.text),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CABECERA
// ===========================================================================

class _Cabecera extends StatelessWidget implements PreferredSizeWidget {
  final bool esModoRuta;
  final Color acento;
  final String? iconoMundo;
  final String titulo;
  final String subtitulo;
  final bool enLinea;
  final bool pensando;
  final bool mostrarTerminar;
  final VoidCallback? onTerminar;

  const _Cabecera({
    required this.esModoRuta,
    required this.acento,
    required this.iconoMundo,
    required this.titulo,
    required this.subtitulo,
    required this.enLinea,
    required this.pensando,
    required this.mostrarTerminar,
    required this.onTerminar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      // AppTheme pone centerTitle: true; aqui el titulo es una fila
      // completa y tiene que ir pegada a la izquierda.
      centerTitle: false,
      toolbarHeight: 66,
      titleSpacing: 4,
      shape: const Border(
        bottom: BorderSide(color: _bordeBurbuja, width: 1),
      ),
      title: Row(
        children: [
          if (esModoRuta)
            CircleAvatar(
              radius: 19,
              backgroundColor: acento.withValues(alpha: 0.14),
              child: Text(iconoMundo ?? '📘',
                  style: const TextStyle(fontSize: 18)),
            )
          else
            MascotaAvatar(size: 38, acento: acento),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: _textoFuerte,
                    height: 1.15,
                  ),
                ),
                if (subtitulo.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (!esModoRuta) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: enLinea ? _verdeVisor : _textoSuave,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        subtitulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: _textoSuave,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                ],
              ],
            ),
          ),
          if (mostrarTerminar)
            TextButton(
              onPressed: onTerminar,
              style: TextButton.styleFrom(
                foregroundColor: acento,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'Terminar',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// BIENVENIDA
//
// Es el único momento con peso visual de la pantalla: la mascota animada,
// una pregunta directa y cuatro atajos. Una pantalla vacía es una invitación
// a actuar, no un hueco.
// ===========================================================================

class _Bienvenida extends StatelessWidget {
  final Color acento;
  final void Function(String) onSugerencia;

  const _Bienvenida({required this.acento, required this.onSugerencia});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: c.maxHeight - 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: MascotaViva(size: 132)),
                const SizedBox(height: 18),
                const Text(
                  '¿Sobre qué norma quieres conversar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: _textoFuerte,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Te oriento con pistas, no resuelvo tus trabajos. Y si algo '
                  'no está en mis documentos, te lo digo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: _textoSuave,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 26),
                for (final s in _sugerencias) ...[
                  _Sugerencia(
                    texto: s,
                    acento: acento,
                    onTap: () => onSugerencia(s),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Sugerencia extends StatelessWidget {
  final String texto;
  final Color acento;
  final VoidCallback onTap;

  const _Sugerencia({
    required this.texto,
    required this.acento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          decoration: BoxDecoration(
            border: Border.all(color: _bordeBurbuja),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: _textoFuerte,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.north_east_rounded, size: 17, color: acento),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// BURBUJAS
// ===========================================================================

class _Burbuja extends StatelessWidget {
  final _Mensaje mensaje;
  final Color acento;

  const _Burbuja({required this.mensaje, required this.acento});

  /// Cada tipo de respuesta se ve distinto, porque significan cosas
  /// distintas: que el tutor no tenga documentación de un tema no es lo
  /// mismo que un error, y ninguna de las dos es una respuesta normal.
  ({Color fondo, Color borde, Color texto, String? etiqueta}) get _estilo {
    switch (mensaje.tipo) {
      case 'sin_contexto':
        return (
          fondo: _arenaFondo,
          borde: _arenaBorde,
          texto: _textoFuerte,
          etiqueta: 'No está en mis documentos',
        );
      case 'redireccion':
        return (
          fondo: _lilaFondo,
          borde: _lilaBorde,
          texto: _textoFuerte,
          etiqueta: 'Fuera del temario',
        );
      case 'error':
      case 'sin_documentos':
        return (
          fondo: _rojoFondo,
          borde: _rojoBorde,
          texto: _textoFuerte,
          etiqueta: null,
        );
      default:
        return (
          fondo: Colors.white,
          borde: _bordeBurbuja,
          texto: _textoFuerte,
          etiqueta: null,
        );
    }
  }

  Color get _colorEtiqueta {
    switch (mensaje.tipo) {
      case 'sin_contexto':
        return _arenaTexto;
      case 'redireccion':
        return _lilaTexto;
      default:
        return _rojoTexto;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    if (mensaje.esUsuario) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 48),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: ancho * 0.76),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreenDark.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              mensaje.texto,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    final e = _estilo;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MascotaAvatar(size: 32, acento: acento),
          const SizedBox(width: 9),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: e.fondo,
                    border: Border.all(color: e.borde),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D1B2559),
                        blurRadius: 12,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (e.etiqueta != null) ...[
                        Text(
                          e.etiqueta!,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: _colorEtiqueta,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        _limpiarMarkdown(mensaje.texto),
                        style: TextStyle(
                          color: e.texto,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.48,
                        ),
                      ),
                    ],
                  ),
                ),
                if (mensaje.nota != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 5),
                    child: Text(
                      mensaje.nota!,
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: _textoSuave),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// El tutor devuelve Markdown ligero. Sin un widget de Markdown, al menos
  /// se quitan los asteriscos y las listas se ven como viñetas. Si algún día
  /// se añade `flutter_markdown`, este método se cambia por un MarkdownBody.
  static String _limpiarMarkdown(String texto) {
    return texto
        // replaceAllMapped, no replaceAll: replaceAll no entiende $1 y
        // dejaría el "$1" literal en el texto.
        .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1] ?? '')
        .replaceAll(RegExp(r'^\s*\*\s+', multiLine: true), '•  ')
        .trim();
  }
}

// ===========================================================================
// ESTADO "PENSANDO"
// ===========================================================================

class _Pensando extends StatelessWidget {
  final Color acento;
  final String? aviso;

  const _Pensando({required this.acento, this.aviso});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MascotaAvatar(size: 32, acento: acento),
          const SizedBox(width: 9),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _bordeBurbuja),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: aviso == null
                  ? PuntosEscribiendo(color: acento)
                  : Text(
                      aviso!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: _textoSuave,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// AVISO BAJO LA CABECERA
// ===========================================================================

class _Aviso extends StatelessWidget {
  final String texto;
  final VoidCallback onCerrar;

  const _Aviso({required this.texto, required this.onCerrar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _arenaFondo,
      padding: const EdgeInsets.fromLTRB(16, 11, 6, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                height: 1.42,
                color: _arenaTexto,
              ),
            ),
          ),
          IconButton(
            iconSize: 17,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close_rounded, color: _arenaTexto),
            onPressed: onCerrar,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// BARRAS INFERIORES
// ===========================================================================

class _BarraEscritura extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEnviar;
  final bool activo;

  const _BarraEscritura({
    required this.controller,
    required this.onEnviar,
    required this.activo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _bordeBurbuja)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: activo,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: _textoFuerte),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: activo
                      ? 'Pregúntale algo al tutor…'
                      : 'Esperando respuesta…',
                  hintStyle: const TextStyle(
                      color: _textoSuave,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                  filled: true,
                  fillColor: _fondo,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                  // Los tres bordes, no solo `border`: el
                  // inputDecorationTheme de AppTheme define enabledBorder y
                  // focusedBorder con 2 px, y esos tienen prioridad.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onEnviar(),
              ),
            ),
            const SizedBox(width: 9),
            Material(
              color: activo ? AppColors.primaryGreen : const Color(0xFFD7DAE4),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: activo ? onEnviar : null,
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Icon(Icons.arrow_upward_rounded,
                      color: Colors.white, size: 21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraReintentar extends StatelessWidget {
  final Color color;
  final VoidCallback onReintentar;
  final VoidCallback onDescartar;

  const _BarraReintentar({
    required this.color,
    required this.onReintentar,
    required this.onDescartar,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _bordeBurbuja)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onDescartar,
                style: TextButton.styleFrom(foregroundColor: _textoSuave),
                child: const Text('Descartar'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Volver a preguntar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraLeccionCompletada extends StatelessWidget {
  final Color color;
  final VoidCallback onVolver;

  const _BarraLeccionCompletada({required this.color, required this.onVolver});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _bordeBurbuja)),
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: color),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '¡Lección completada! Se desbloqueó la siguiente.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textoFuerte,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onVolver,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
