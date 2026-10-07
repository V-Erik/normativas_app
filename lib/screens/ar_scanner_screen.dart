import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rive/rive.dart' as rive;
import '../services/chat_service.dart'; // <-- IMPORTANTE: Importamos tu servicio de IA

class ArScannerScreen extends StatefulWidget {
  const ArScannerScreen({super.key});

  @override
  State<ArScannerScreen> createState() => _ArScannerScreenState();
}

class _ArScannerScreenState extends State<ArScannerScreen> {
  bool _isScanned = false;
  String _codigoDetectado = '';
  
  // Variables nuevas para la IA
  bool _isLoadingIA = false; 
  String _respuestaTutor = '';

  // API nueva de rive 0.14+. Cargamos el archivo y creamos el
  // controlador de forma manual, indicando EXPLÍCITAMENTE el nombre de
  // la State Machine ("State Machine 1") en vez de dejar que Rive elija
  // una por defecto — si el .riv tiene más de una, dejarlo "automático"
  // puede terminar mostrando una vacía o sin animación.
  rive.File? _riveFile;
  rive.RiveWidgetController? _riveController;
  String? _riveError;

  @override
  void initState() {
    super.initState();
    _cargarAvatarRive();
  }

  Future<void> _cargarAvatarRive() async {
    try {
      final file = await rive.File.asset(
        'assets/models/iso_tutor.riv',
        riveFactory: rive.Factory.rive,
      );
      if (file == null) {
        setState(() => _riveError = 'No se pudo decodificar el archivo .riv');
        return;
      }
      final controller = rive.RiveWidgetController(file);
      // Imprime en consola el nombre real de la State Machine que se
      // cargó, por si luego quieres forzarla explícitamente por nombre.
      debugPrint('Rive: State Machine cargada -> ${controller.stateMachine.name}');
      if (!mounted) return;
      setState(() {
        _riveFile = file;
        _riveController = controller;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _riveError = e.toString());
    }
  }

  @override
  void dispose() {
    _riveController?.dispose();
    _riveFile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isScanned ? 'Tutor IA Activo' : 'Escanea una Norma ISO',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      // Usamos Stack para apilar la animación sobre el video en vivo
      body: Stack(
        children: [
          // 1. FONDO: La cámara siempre encendida
          MobileScanner(
            onDetect: (capture) async { // <-- Lo hacemos asíncrono para esperar a la IA
              // Solo procesa si no ha escaneado nada y la IA no está pensando
              if (!_isScanned && !_isLoadingIA) { 
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    setState(() {
                      _codigoDetectado = barcode.rawValue!;
                      _isScanned = true;
                      _isLoadingIA = true; // La IA empieza a pensar
                    });

                    // ¡Llamamos al cerebro de la IA en tu backend!
                    final respuestaIA = await ChatService.preguntarAlTutor(
                      "Hola, el estudiante escaneó la norma $_codigoDetectado. Explícala brevemente."
                    );

                    if (mounted) {
                      setState(() {
                        _respuestaTutor = respuestaIA;
                        _isLoadingIA = false; // La IA ya tiene la respuesta
                      });
                    }
                    
                    break;
                  }
                }
              }
            },
          ),

          // 2. FRENTE: Cambia según el estado de _isScanned
          if (!_isScanned) ...[
            // --- MODO CAZADOR (Mira y texto) ---
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent, width: 4),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Apunta a un código QR o diagrama de la normativa',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ] else ...[
            // --- MODO REALIDAD AUMENTADA (Avatar flotando) ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Globo de texto con el resultado de la IA
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10)
                      ]
                    ),
                    child: Column(
                      children: [
                        Text(
                          // Aquí cambiamos el texto dinámicamente
                          _isLoadingIA 
                              ? '¡Norma $_codigoDetectado detectada!\n\nDejame consultar mis documentos...' 
                              : _respuestaTutor,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: _isLoadingIA ? Colors.grey.shade700 : Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Escanear otra norma'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isScanned = false;
                              _codigoDetectado = '';
                              _respuestaTutor = ''; // Limpiamos la respuesta de la IA
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  // ¡Aquí entra tu Tutor ISO animado en Rive! (Intacto)
                  SizedBox(
                    width: 320,
                    height: 320,
                    child: _riveError != null
                        ? Center(
                            child: Text(
                              'No se pudo cargar el tutor:\n$_riveError',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : _riveController == null
                            ? const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : rive.RiveWidget(
                                controller: _riveController!,
                                fit: rive.Fit.contain,
                              ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}