"""Genera los clips de voz de la mascota a partir de casos_ra.dart.

QUÉ HACE

Lee el catálogo de casos, extrae cada frase que la mascota llega a decir
y sintetiza un MP3 por frase en assets/voz/. La app los reproduce; si
alguno falta, habla el motor del teléfono como respaldo, así que la
aplicación funciona igual con los clips y sin ellos.

POR QUÉ UN SCRIPT Y NO GRABARLOS A MANO

Porque los textos cambian. La noche del 27 reescribimos trece reacciones
de golpe, y una voz grabada a mano se habría quedado diciendo lo
anterior sin que nadie se enterase: el estudiante leería una cosa y
oiría otra. Aquí el MP3 se deriva del mismo archivo que la app muestra en
pantalla, y el manifiesto guarda el hash de cada texto, de modo que al
volver a ejecutarlo solo se regenera lo que cambió y se avisa de ello.

CÓMO SE USA

    pip install edge-tts
    python generar_voces.py

Desde la raíz del proyecto Flutter. Por defecto lee lib/data/casos_ra.dart
y escribe en assets/voz/.

    python generar_voces.py --voz es-EC-AndreaNeural   # otra voz
    python generar_voces.py --listar-voces             # ver las de español
    python generar_voces.py --todo                     # regenerar todo

La síntesis es de Microsoft Edge y no necesita cuenta ni clave. Requiere
conexión únicamente mientras se generan los clips: la aplicación los
reproduce desde el propio paquete, sin red. Esto importa para el
documento, porque el apartado 4.2.1.5 sostiene que ninguna consulta del
estudiante sale de la infraestructura institucional, y aquí no sale
ninguna: lo que viaja es el texto fijo de los casos, una sola vez, desde
el equipo de desarrollo.
"""
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

VOZ_POR_DEFECTO = 'es-MX-DaliaNeural'

# Un poco más lento que el natural: son explicaciones, no titulares.
RITMO_POR_DEFECTO = '-8%'

# La pregunta es la misma en los ocho casos, así que se sintetiza una vez.
PREGUNTA = '¿Qué normativa aplicarías aquí?'
CLAVE_PREGUNTA = '__pregunta'

# La frase con la que se auditan las voces. Es una del catálogo y no un
# «hola, qué tal»: tiene una cifra, dos puntos y una subordinada, que es
# donde se nota si una voz entona o recita.
MUESTRA = ('Eso es. Son datos de salud: antes de que funcione bonito tiene '
           'que estar protegido, y el marco para eso es la ISO 27001.')


# --------------------------------------------------------------- lectura
def literal(bloque: str, desde: int) -> tuple[str, int]:
    """Lee una cadena Dart desde `desde`, uniendo literales contiguos.

    En Dart dos literales separados solo por espacios se concatenan, y así
    es como está escrito casos_ra.dart: cada frase larga viene partida en
    varias líneas entrecomilladas.
    """
    patron = re.compile(r"\s*'((?:[^'\\]|\\.)*)'")
    partes, i = [], desde
    while True:
        m = patron.match(bloque, i)
        if not m:
            break
        partes.append(m.group(1))
        i = m.end()
    texto = ''.join(partes).replace("\\'", "'").replace('\\"', '"')
    return re.sub(r'\s+', ' ', texto).strip(), i


def campo(bloque: str, nombre: str) -> str:
    marca = f'{nombre}: '
    i = bloque.find(marca)
    if i < 0:
        return ''
    return literal(bloque, i + len(marca))[0]


def leer_casos(ruta: Path) -> list[dict]:
    fuente = ruta.read_text(encoding='utf-8')
    casos = []
    for bloque in fuente.split('    CasoRA(')[1:]:
        idc = campo(bloque, 'id')
        if not idc:
            continue
        corte = bloque.find('primerPaso')
        seccion = bloque[bloque.find('opciones: ['):corte]
        opciones = []
        for trozo in seccion.split('OpcionNorma(')[1:]:
            etiqueta, fin = literal(trozo, 0)
            reaccion, _ = literal(trozo, trozo.index(',', fin) + 1)
            opciones.append({'etiqueta': etiqueta, 'reaccion': reaccion})
        casos.append({
            'id': idc,
            'enganche': campo(bloque, 'enganche'),
            'primerPaso': campo(bloque, 'primerPaso'),
            'opciones': opciones,
        })
    return casos


def frases(casos: list[dict]) -> dict[str, str]:
    """Todas las frases que la mascota puede decir, con su clave.

    Las claves son las mismas que calcula la app en _claveDeVoz, y de esa
    coincidencia depende todo: si aquí se renombra una, allí deja de
    encontrarse el clip y esa frase pasa a leerla el motor del teléfono.
    """
    salida = {CLAVE_PREGUNTA: PREGUNTA}
    for c in casos:
        salida[f"{c['id']}__enganche"] = c['enganche']
        salida[f"{c['id']}__paso"] = c['primerPaso']
        for n, o in enumerate(c['opciones']):
            salida[f"{c['id']}__op{n}"] = o['reaccion']
    return {k: v for k, v in salida.items() if v}


# ------------------------------------------------------------- síntesis
def sintetizar(texto: str, destino: Path, voz: str, ritmo: str,
               intentos: int = 4) -> None:
    """Sintetiza una frase, reintentando si el servicio no manda audio.

    El error «NoAudioReceived» no suele indicar nada malo en el texto: el
    servicio corta peticiones cuando llegan muchas seguidas, y con
    cuarenta y una llegan muchas seguidas. Se reintenta con esperas
    crecientes antes de darlo por perdido.
    """
    orden = [
        'edge-tts', '--voice', voz,
        # Pegado con «=» a propósito. Un ritmo negativo como «-8%» empieza
        # por guion, y pasado como dos argumentos argparse lo toma por otra
        # opción y deja a --rate sin valor.
        f'--rate={ritmo}',
        '--text', texto, '--write-media', str(destino), '--no-progress',
    ]
    ultimo = ''
    for intento in range(1, intentos + 1):
        r = subprocess.run(orden, capture_output=True, text=True)
        if (r.returncode == 0 and destino.exists()
                and destino.stat().st_size > 0):
            return
        destino.unlink(missing_ok=True)
        ultimo = r.stderr.strip()[-300:] or 'edge-tts no produjo audio'
        if intento < intentos:
            espera = 2 * intento
            print(f'      reintento {intento} en {espera}s…')
            time.sleep(espera)
    raise RuntimeError(ultimo)


def voces_en_espanol() -> list[tuple[str, str]]:
    """Todas las voces en español del servicio, con su género.

    Se consulta por la API de Python porque devuelve campos con nombre; la
    salida de la línea de comandos cambia de formato entre versiones y
    analizarla a mano es frágil. Si por lo que sea no se puede importar el
    módulo, se recurre a la lista impresa.
    """
    try:
        import asyncio

        import edge_tts

        todas = asyncio.run(edge_tts.list_voices())
        pares = {
            (v['ShortName'], v.get('Gender', ''))
            for v in todas
            if str(v.get('ShortName', '')).lower().startswith('es-')
        }
        return sorted(pares)
    except Exception:
        r = subprocess.run(['edge-tts', '--list-voices'],
                           capture_output=True, text=True)
        nombres = set(re.findall(r'\bes-[A-Z]{2}-\w+Neural\b', r.stdout))
        return sorted((n, '') for n in nombres)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--casos', default='lib/data/casos_ra.dart')
    ap.add_argument('--salida', default='assets/voz')
    ap.add_argument('--voz', default=VOZ_POR_DEFECTO)
    ap.add_argument('--ritmo', default=RITMO_POR_DEFECTO)
    ap.add_argument('--todo', action='store_true',
                    help='regenera también lo que no ha cambiado')
    ap.add_argument('--listar-voces', action='store_true',
                    help='muestra las voces en español disponibles')
    ap.add_argument('--prueba', action='store_true',
                    help='sintetiza una sola frase para oír la voz antes '
                         'de generar las 41')
    ap.add_argument('--probar-todas', action='store_true',
                    help='una muestra de CADA voz en español, en '
                         'pruebas_voz/, para elegir de oído')
    ap.add_argument('--genero', choices=['Female', 'Male'],
                    help='con --probar-todas, limita a un género')
    args = ap.parse_args()

    if shutil.which('edge-tts') is None:
        print('Falta edge-tts.  Instálalo con:  pip install edge-tts')
        return 1

    if args.listar_voces:
        for nombre, genero in voces_en_espanol():
            print(f'{nombre:28} {genero}')
        return 0

    if args.probar_todas:
        voces = voces_en_espanol()
        if args.genero:
            voces = [v for v in voces if v[1] == args.genero]
        if not voces:
            print('No obtuve la lista de voces. ¿Hay conexión?')
            return 1

        carpeta = Path('pruebas_voz')
        carpeta.mkdir(exist_ok=True)
        print(f'{len(voces)} voces  ·  una muestra de cada una en '
              f'{carpeta}/\n')

        fallaron = []
        for nombre, genero in voces:
            destino = carpeta / f'{nombre}.mp3'
            if destino.exists() and destino.stat().st_size > 0:
                print(f'  = {nombre:28} {genero}  (ya estaba)')
                continue
            try:
                # Dos intentos bastan aquí: si una voz concreta falla, se
                # salta y se sigue. No vale la pena esperar por una
                # muestra que es solo para elegir.
                sintetizar(MUESTRA, destino, nombre, args.ritmo, intentos=2)
                print(f'  · {nombre:28} {genero}')
                time.sleep(0.4)
            except Exception:
                fallaron.append(nombre)
                print(f'  ! {nombre:28} {genero}  (sin audio)')

        print(f'\nEscúchalas en {carpeta.resolve()}')
        if fallaron:
            print('sin audio:', ', '.join(fallaron))
        print('\nCuando elijas:\n'
              '  python generar_voces.py --voz <la-que-sea>')
        return 0

    if args.prueba:
        # Una frase cualquiera del catálogo sirve para juzgar la voz, y
        # vale la pena oírla antes de sintetizar las cuarenta y una.
        muestra = Path('prueba_voz.mp3')
        try:
            sintetizar(MUESTRA, muestra, args.voz, args.ritmo)
        except Exception as e:
            print('Falló:', e)
            return 1
        print(f'Escucha {muestra.resolve()}\n'
              f'voz {args.voz}  ·  ritmo {args.ritmo}')
        return 0

    casos_path = Path(args.casos)
    if not casos_path.exists():
        print(f'No encuentro {casos_path}. ¿Estás en la raíz del proyecto?')
        return 1

    casos = leer_casos(casos_path)
    todas = frases(casos)
    print(f'{len(casos)} casos  ·  {len(todas)} frases')

    salida = Path(args.salida)
    salida.mkdir(parents=True, exist_ok=True)
    manifiesto_path = salida / 'voces.json'

    previo = {}
    if manifiesto_path.exists():
        try:
            previo = json.loads(manifiesto_path.read_text(encoding='utf-8'))
            previo = previo.get('hashes', {})
        except Exception:
            previo = {}

    nuevo, hechas, saltadas, fallos = {}, 0, 0, []
    for clave, texto in sorted(todas.items()):
        firma = hashlib.sha1(
            f'{args.voz}|{args.ritmo}|{texto}'.encode('utf-8')
        ).hexdigest()
        nuevo[clave] = firma
        mp3 = salida / f'{clave}.mp3'

        if not args.todo and mp3.exists() and previo.get(clave) == firma:
            saltadas += 1
            continue

        motivo = 'nuevo' if clave not in previo else 'cambió el texto'
        print(f'  · {clave}  ({motivo})')
        try:
            sintetizar(texto, mp3, args.voz, args.ritmo)
            hechas += 1
            # Un respiro entre peticiones. Encadenadas sin pausa, el
            # servicio empieza a devolver respuestas vacías.
            time.sleep(0.4)
        except Exception as e:
            fallos.append((clave, str(e)))

    # Los clips de claves que ya no existen estorban en el paquete.
    sobrantes = []
    for mp3 in salida.glob('*.mp3'):
        if mp3.stem not in todas:
            sobrantes.append(mp3.name)

    # El manifiesto solo declara lo que existe de verdad en el disco. La
    # app decide con esta lista si reproduce un clip o si manda la frase
    # al motor del teléfono, así que anunciar un MP3 que no se generó la
    # haría intentar reproducir un archivo ausente. Y al dejar fuera el
    # hash de lo que falló, la siguiente ejecución vuelve a intentarlo.
    reales = {
        clave: firma for clave, firma in nuevo.items()
        if (salida / f'{clave}.mp3').exists()
        and (salida / f'{clave}.mp3').stat().st_size > 0
    }

    manifiesto_path.write_text(
        json.dumps(
            {'voz': args.voz, 'ritmo': args.ritmo,
             'claves': sorted(reales), 'hashes': reales},
            ensure_ascii=False, indent=2),
        encoding='utf-8')

    print(f'\ngeneradas {hechas}  ·  sin cambios {saltadas}'
          f'  ·  fallaron {len(fallos)}')
    if sobrantes:
        print('sobran (bórralos a mano):', ', '.join(sobrantes))
    if fallos:
        print('\nFALLARON:')
        for clave, err in fallos:
            print(f'  {clave}: {err}')
        return 1

    print(f'\nListo en {salida}/.  Falta que el pubspec.yaml incluya:\n'
          '\nflutter:\n  assets:\n    - assets/voz/\n')
    return 0


if __name__ == '__main__':
    sys.exit(main())