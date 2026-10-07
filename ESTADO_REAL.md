# Estado real de la app Flutter (`PROYECTO/app`)

Inventario hecho el 2026-10-06 leyendo cada archivo de `lib/`, `pubspec.yaml`,
`android/app/build.gradle.kts`, `AndroidManifest.xml` y `test/`, y ejecutando `flutter analyze` y
`flutter build web` (Flutter 3.44.8 stable). Leyenda: ✅ existe y funciona · 🟡 a medias / maqueta · ❌ no existe.

> Aviso: la copia **más antigua** del frontend (`PROYECTO/normativas_app/`, sin login ni mundos) se archivó el
> mismo día como `PROYECTO/_ARCHIVO_normativas_app_vieja/`, y `PROYECTO/CLAUDE.md` ya describe `app/` como el
> frontend vigente. Este documento describe solo `app/`.

---

## 1. Estructura de `lib/` ✅

23 archivos `.dart`, 3 125 líneas. No hay carpeta `services/`, ni `providers/`, ni `data/`, ni `config/`.

| Carpeta | Archivos (líneas) |
|---|---|
| `lib/` | `main.dart` (26) |
| `models/` | `chat_message.dart` (9), `normativa.dart` (21), `seccion_iso.dart` (40) |
| `screens/` | `ar_scanner_screen.dart` (134), `chat_screen.dart` (374), `home_screen.dart` (231), `iso_level_screen.dart` (61), `iso_roadmap_screen.dart` (59), `login_screen.dart` (166), `main_scaffold.dart` (33), `profile_screen.dart` (242), `register_screen.dart` (177) |
| `theme/` | `app_theme.dart` (108) |
| `widgets/` | `app_bottom_nav.dart` (163), `auth_background.dart` (53), `duo_button.dart` (103), `duolingo_level_node.dart` (259), `duolingo_section_header.dart` (65), `duolingo_zigzag_path.dart` (257), `glass_card.dart` (34), `neumorphic_text_field.dart` (77), `top_stats_bar.dart` (112) |

Dependencias reales (`pubspec.yaml`): `http`, `lottie`, `mobile_scanner`, `model_viewer_plus`. **No** hay
`firebase_core`, `firebase_auth`, `shared_preferences`, ni ningún gestor de estado.

## 2. Los 4 mundos, lecciones y contenido didáctico — 🟡 solo la parte visual

- **Mundos: existen 4, pero son 4 normas, no las 4 unidades del sílabo.** Están escritos a mano como lista
  `const` en `lib/screens/home_screen.dart:16-70`:
  1. ISO/IEC 25010 – "Introducción a la ISO/IEC 25010" (5 niveles)
  2. ISO/IEC 12207 – "Ciclo de Vida del Software" (4 niveles)
  3. ISO/IEC 27001 – "Seguridad de la Información" (4 niveles)
  4. ISO/IEC 33001 – "Evaluación de Procesos de Software" (4 niveles)

  El sílabo tiene otras 4 unidades (Metodologías · Normativas y calidad · Métricas · Pruebas/implementación/
  mantenimiento); ningún mundo cubre metodologías ágiles, métricas ni pruebas.
- **Lecciones: 17 "niveles", 0 con contenido.** Cada nivel es un `NivelRuta` con **solo** un ícono y un estado
  (`lib/models/seccion_iso.dart:7-12`): no tiene id, título, texto, preguntas ni ejercicios.
- **No existe pantalla de lección.** Al tocar el nivel "actual", `IsoLevelScreen._onTapNivel`
  (`lib/screens/iso_level_screen.dart:16-21`) solo hace `debugPrint`; el comentario lo admite: "Por ahora no hay
  lógica de navegación a la lección en sí".
- **El estado está fijo en código**: el mundo 1 aparece con 2 niveles completados y 1 actual; los mundos 2-4
  están bloqueados para siempre, porque nada cambia esos `const`. Ningún usuario puede desbloquear nada.
- No hay quizzes, ni JSON/asset de contenido, ni ids de lección compatibles con
  `servidor/configuracion/lecciones.json` (que espera ids como `leccion-iso-25010`).

## 3. Login y registro — 🟡 maqueta

- Existen `lib/screens/login_screen.dart` y `lib/screens/register_screen.dart`, con buen diseño y validación de
  formulario (correo con `@`, contraseña ≥ 4 caracteres, nombre ≥ 3).
- **No autentican nada.** `_iniciarSesion` (`login_screen.dart:31-43`) y `_registrar`
  (`register_screen.dart:33-45`) hacen `Future.delayed(600/700 ms)` — comentario literal: "Simula la llamada a
  un backend" — y luego navegan a `MainScaffold`. Cualquier correo/contraseña entra.
- No se guarda ningún usuario, token ni sesión; el nombre ingresado en el registro se descarta.
- El usuario es fijo en código: `'Erik'` en `home_screen.dart:14` y `'Erik Daniel Yuquilema Galarraga'` en
  `profile_screen.dart:7`.
- No hay cierre de sesión, recuperación de contraseña, ni pantalla de consentimiento.

## 4. `chat_service.dart` — ❌ no existe

La llamada HTTP está dentro de la pantalla, `lib/screens/chat_screen.dart:69-122` (`sendMessage`):

| | Lo que hace la app | Lo que espera el backend real (`servidor/docs/contrato_api.md`) |
|---|---|---|
| URL | `http://10.0.2.2:5000/api/chat` (`chat_screen.dart:28`, constante) | `http://<host>:8000/api/v1/chat` |
| Cabeceras | solo `Content-Type: application/json` | + `Authorization: Bearer <id_token de Firebase>` |
| Cuerpo | `{"message": ..., "normativa": ...}` | `{"mensaje": ..., "conversacion_id"?: ..., "leccion_id"?: ...}` |
| Respuesta leída | `data['reply'] ?? data['response']` | `respuesta` (+ `tipo`, `conversacion_id`, `desde_cache`, `posicion_en_cola`, …) |
| Timeout | 20 s | una generación tarda ~10-13 s y la cola puede esperar hasta 90 s |

Conclusión: **hoy el chat no puede hablar con el backend**: puerto y ruta erróneos, nombres de campo erróneos
(un 422 aunque tuviera token), sin token (401), sin `conversacion_id` (cada mensaje es una conversación nueva:
el tutor pierde la memoria), y el timeout corta respuestas legítimas.

Otros detalles:
- `normativa` siempre es `null`: `ChatScreen` se crea sin argumentos en `main_scaffold.dart:23` y en ningún otro
  lugar, y el modelo `Normativa` nunca se instancia.
- El historial vive en una `List` en memoria (`chat_screen.dart:32`): se pierde al cerrar la app.
- `_lanzarVisorAr` (`chat_screen.dart:124-142`) añade un mensaje fijo del "tutor" ("📦 Lanzando modelo 3D…") y un
  SnackBar "Abriendo Escáner AR…", pero **no abre nada**. Además viola la regla de producto de un único mensaje
  predefinido (el saludo).

## 5. `progreso_service.dart` — ❌ no existe

No hay progreso guardado en ningún lado: ni en memoria (no hay estado mutable de progreso), ni
`SharedPreferences` (no está en dependencias), ni backend. Todo lo que aparece como progreso es literal en código:
- Racha `12` (`home_screen.dart:112`), progreso total calculado sobre los `const` (siempre 0 %, porque ningún
  mundo está "completado").
- Perfil: racha "12 días", medallas "7", nivel "Intermedio", XP "340" (`profile_screen.dart:39-62`). La
  sección "Configuración" (notificaciones/tema/idioma) son filas de texto sin acción.

## 6. Realidad aumentada — 🟡 solo la pantalla; no hay AR

`lib/screens/ar_scanner_screen.dart`:
- Lo que **sí** hace: abre la cámara con `mobile_scanner` y lee cualquier código QR/de barras; muestra el texto
  crudo leído ("¡Norma detectada: <texto>!") y un botón para volver a escanear.
- Lo que **no** hace: no hay seguimiento de superficies, anclas, ni modelo 3D en el espacio. La "realidad
  aumentada" es una animación 2D de Lottie superpuesta sobre el video (`Lottie.network(...)`, línea 125), que
  además **requiere internet** y depende de una URL externa de lottiefiles.com.
- No valida que el código corresponda a una norma ni lo conecta con el chat o con una lección.
- `model_viewer_plus` está en `pubspec.yaml` y `assets/models/avatar.glb` (**27 MB**) está declarado como asset,
  pero **ninguno se usa** en `lib/` (búsqueda de `ModelViewer`/`model_viewer`/`avatar.glb`: 0 resultados). El
  APK carga 27 MB muertos.

## 7. Navegación: pantallas conectadas vs. código muerto

Flujo real: `main.dart` → ruta inicial `/login` → `LoginScreen` ⇄ `RegisterScreen` → `MainScaffold`
(barra inferior con 4 pestañas en `IndexedStack`) → `HomeScreen` → `IsoLevelScreen`.

| Pantalla / widget | Estado |
|---|---|
| `LoginScreen`, `RegisterScreen` | ✅ conectadas |
| `MainScaffold` + `AppBottomNavBar` | ✅ conectadas |
| `HomeScreen`, `ChatScreen`, `ArScannerScreen`, `ProfileScreen` | ✅ conectadas (pestañas) |
| `IsoLevelScreen` | ✅ conectada (desde `HomeScreen._abrirNorma`), solo el mundo 1 se puede abrir |
| `IsoRoadmapScreen` (`iso_roadmap_screen.dart`) | ❌ **código muerto y roto**: nadie la importa y no compila (ver punto 9) |
| `DuolingoLevelNode` (`widgets/duolingo_level_node.dart`, 259 líneas) | ❌ código muerto (sin referencias; `duolingo_zigzag_path.dart` tiene su propio nodo) |
| Modelo `Normativa` | ❌ muerto en la práctica (solo es el tipo de un parámetro que nunca se pasa) |
| Ruta con nombre `/home` (`main.dart:25`) | ❌ nunca usada (todo navega con `MaterialPageRoute`) |

## 8. Android: applicationId y minSdk

- El archivo es `android/app/build.gradle.kts` (Kotlin DSL; no existe `build.gradle`).
- `applicationId = "com.example.normativas_app"` (línea 19), igual que `namespace`. Sigue el valor de plantilla
  con el `TODO` de Flutter; Google Play rechaza `com.example.*`.
- `minSdk = flutter.minSdkVersion` (línea 22): no está fijado en el proyecto; con Flutter 3.44.8 instalado vale
  **24** (`flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt:26`). `targetSdk`/`compileSdk` también
  delegan en Flutter.
- Release se firma con la clave debug (`buildTypes.release`, línea 32).
- `AndroidManifest.xml`: permisos `INTERNET` y `CAMERA`, `usesCleartextTraffic="true"` (permite HTTP sin TLS),
  label `normativas_app`.

## 9. ¿Compila? `flutter analyze` — 🟡 la app sí, el proyecto no limpio

`flutter analyze`: **36 issues = 4 errores + 32 infos**.

Errores:
1. `lib/screens/iso_roadmap_screen.dart:34:26` — falta el argumento requerido `nombre` de `TopStatsBar`.
2. `lib/screens/iso_roadmap_screen.dart:34:49` — el parámetro `gemas` no existe.
3. `lib/screens/iso_roadmap_screen.dart:34:61` — el parámetro `energia` no existe.
   (Los tres porque `TopStatsBar` se rediseñó — "Reemplaza al antiguo HUD de vidas/gemas/energía" — y esta
   pantalla no se actualizó.)
4. `test/widget_test.dart:16:35` — `MyApp` no existe (es el test del contador de la plantilla; la clase se llama
   `NormativasApp`). **`flutter test` falla**: no hay ningún test real.

Infos: 32 × `withOpacity` deprecado (usar `.withValues(alpha: …)`), repartidos en casi todos los archivos.

**La app sí se construye**: `flutter build web` terminó con `√ Built build\web`, porque
`iso_roadmap_screen.dart` no es alcanzable desde `main.dart` y el compilador no lo incluye. No se probó
`flutter build apk` en esta revisión.

---

## Lo que falta para conectarse a un backend con autenticación y guardar el progreso por estudiante

El backend (`servidor/`) ya tiene todo lo necesario del lado servidor: Firebase Auth, consentimiento,
`POST /api/v1/chat` con contrato en español, `GET /api/v1/salud`, `GET /api/v1/progreso/mio`,
`POST /api/v1/progreso/lecciones/{id}/completar`, `POST /api/v1/progreso/ejercicios/{id}/resolver`
(ver `servidor/docs/contrato_api.md`). Lo que falta está en la app:

**Autenticación**
1. Crear un proyecto Firebase para la app y añadir `firebase_core` + `firebase_auth` (y `flutterfire configure`:
   `google-services.json`, `firebase_options.dart`). Debe ser el **mismo proyecto Firebase** cuyas credenciales
   usa el backend (`FIREBASE_CREDENTIALS_PATH`).
2. Cambiar `applicationId` de `com.example.normativas_app` a uno propio **antes** de registrar la app Android en
   Firebase (el id queda atado al registro).
3. Reemplazar los `Future.delayed` de `login_screen.dart` / `register_screen.dart` por
   `signInWithEmailAndPassword` / `createUserWithEmailAndPassword` (+ `updateDisplayName` con el nombre), con
   manejo de errores (correo en uso, contraseña débil — Firebase exige ≥ 6, la app valida ≥ 4).
4. Arranque según sesión (`authStateChanges`) en lugar de `initialRoute: '/login'` fijo; botón de cerrar sesión
   en el perfil.
5. Pantalla de consentimiento que llame a `POST /api/v1/usuarios/consentimiento` (sin ella `/chat` responde 409).

**Capa de red**
6. `lib/services/api_client.dart` (o similar) con la URL base configurable (`--dart-define`; `10.0.2.2` en
   emulador, IP LAN en dispositivo, `localhost` en web/escritorio) y que añada
   `Authorization: Bearer ${await user.getIdToken()}` a cada petición, refrescando el token.
7. `chat_service.dart`: `POST /api/v1/chat` con `{mensaje, conversacion_id, leccion_id}`, leer `respuesta`,
   guardar y reenviar el `conversacion_id` devuelto, timeout ≥ 120 s, mensajes distintos para 401/409/503
   (cola llena), y mostrar `posicion_en_cola`/`espera_estimada_s`.
8. Consultar `GET /api/v1/salud` antes de habilitar el campo de texto del chat.
9. Quitar el mensaje fijo de `_lanzarVisorAr` (o hacer que abra la pantalla AR de verdad).

**Contenido y progreso**
10. Decidir si los mundos son las 4 unidades del sílabo o normas sueltas, y modelar lecciones con contenido real
    (id, título, texto, ejercicios) — hoy no hay ni una.
11. Usar como `leccion_id` los mismos ids que `servidor/configuracion/lecciones.json` (y añadir allí cada
    lección nueva), y pasarlo al chat cuando se abre desde una lección.
12. `progreso_service.dart`: leer `GET /progreso/mio` al iniciar y llamar a `.../completar` y
    `.../resolver` al terminar lecciones/ejercicios.
13. Un estado compartido (p. ej. `ChangeNotifier`/`provider`) para que Home, IsoLevel y Perfil muestren el
    progreso real en vez de los números fijos (racha 12, XP 340, "Erik"), y que el desbloqueo de niveles y
    mundos dependa de ese progreso.
14. Opcional: caché local (`shared_preferences`) para mostrar el progreso sin red; la fuente de verdad sigue
    siendo el backend.

**Limpieza para que el proyecto quede verde**
15. Borrar o arreglar `iso_roadmap_screen.dart` y `duolingo_level_node.dart`; reescribir
    `test/widget_test.dart` (`flutter analyze` sin errores, `flutter test` en verde).
16. Quitar `model_viewer_plus` y el `avatar.glb` de 27 MB si no se va a usar, o usarlo de verdad en la pantalla AR;
    empaquetar la animación Lottie como asset local en vez de `Lottie.network`.
17. Para producción: HTTPS en el backend y retirar `usesCleartextTraffic="true"`; firma de release propia.
