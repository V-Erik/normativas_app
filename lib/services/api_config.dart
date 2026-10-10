/// Configuración de red del backend "Tutor IA"
/// (carpeta `servidor/` del repositorio guia-didactica-ra-ia).
///
/// No hace falta tocar el código para cambiar de máquina:
///
///   flutter run --dart-define=API_BASE=http://192.168.1.50:8000
///
/// Qué valor usar según desde dónde corre la app:
///
///   Emulador Android en el mismo PC ..... http://10.0.2.2:8000   (por defecto)
///   Teléfono físico en la misma wifi .... `http://<IPv4 del PC>:8000`
///                                         (el servidor debe arrancar con
///                                          --host 0.0.0.0 y el Firewall de
///                                          Windows abrir el puerto 8000)
///   Flutter web o escritorio ............ http://127.0.0.1:8000
class ApiConfig {
  /// Raíz del servidor, sin barra final.
  static const String base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// Todas las rutas del backend viven bajo /api/v1.
  static const String v1 = '$base/api/v1';

  /// 120 s máximos de espera en la cola de generación
  /// (ESPERA_MAXIMA_COLA_S) + ~15 s de generación en el peor caso medido
  /// + margen. Con menos, la app corta antes de recibir el 503 que
  /// explicaría la saturación.
  static const Duration timeoutChat = Duration(seconds: 150);

  /// El servidor espera como mucho 2 s a Ollama.
  static const Duration timeoutSalud = Duration(seconds: 5);

  /// /cola/estado es instantáneo.
  static const Duration timeoutCola = Duration(seconds: 5);

  /// /usuarios, /perfil, /progreso e /historial solo consultan la base
  /// de datos: responden en milisegundos.
  static const Duration timeoutDatos = Duration(seconds: 15);

  /// Cada cuánto se consulta el estado de la cola mientras se espera
  /// una respuesta del tutor.
  static const Duration intervaloSondeoCola = Duration(seconds: 3);

  /// Timeout corto para las llamadas del arranque (/usuarios/yo,
  /// /progreso/mio). Estas NO deben hacer esperar al estudiante: si el
  /// servidor no está, la app tiene que entrar igual y dejarlo usar las
  /// lecciones. Con el timeout normal de 15 s, iniciar sesión sin
  /// servidor tardaba medio minuto.
  static const Duration timeoutArranque = Duration(seconds: 4);
}
