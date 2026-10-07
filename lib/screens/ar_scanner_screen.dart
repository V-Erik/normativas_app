import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:lottie/lottie.dart';

class ArScannerScreen extends StatefulWidget {
  const ArScannerScreen({super.key});

  @override
  State<ArScannerScreen> createState() => _ArScannerScreenState();
}

class _ArScannerScreenState extends State<ArScannerScreen> {
  bool _isScanned = false; 
  String _codigoDetectado = '';

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
            onDetect: (capture) {
              if (!_isScanned) { // Solo procesa si no ha escaneado nada aún
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    setState(() {
                      _codigoDetectado = barcode.rawValue!;
                      _isScanned = true;
                    });
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
                  color: Colors.black.withValues(alpha: 0.7),
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
                  // Globo de texto con el resultado
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10)
                      ]
                    ),
                    child: Column(
                      children: [
                        Text(
                          '¡Norma detectada:\n$_codigoDetectado!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
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
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  // Animación 2D flotando en tu cámara
                  Lottie.network(
                    'https://assets8.lottiefiles.com/packages/lf20_ikvz7qhc.json', 
                    width: 320,
                    height: 320,
                    fit: BoxFit.contain,
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