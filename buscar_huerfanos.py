"""Encuentra los archivos de lib/ a los que la aplicacion no llega.

COMO LO DECIDE

No busca "archivos que nadie importa", que es lo que se hace a ojo y deja
fuera los subarboles: una pantalla vieja que ya no se abre desde ningun
sitio pero que importa dos widgets suyos haria que esos dos widgets
parecieran usados.

Lo que hace es partir de lib/main.dart y seguir cada import, export y
part hacia adentro, marcando todo lo que alcanza. Lo que queda sin marcar
no esta conectado a la aplicacion por ningun camino, y se va entero.

LO QUE NO PUEDE SABER

Es analisis estatico: ve las referencias escritas en los directivas. No
ve nada que se resuelva en tiempo de ejecucion. Por eso, de cada huerfano
tambien busca su nombre suelto por todo el proyecto: si aparece citado en
algun sitio que no sea un import, lo marca con CUIDADO para que lo mires
antes de borrarlo.

Tampoco entra en test/: los archivos que solo usan las pruebas salen como
huerfanos, pero se avisa de cuales son.

USO

    python buscar_huerfanos.py              (desde la raiz del proyecto)
    python buscar_huerfanos.py <ruta>
"""
import re
import sys
from pathlib import Path

RAIZ = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()
LIB = RAIZ / 'lib'
TEST = RAIZ / 'test'

if not LIB.is_dir():
    raise SystemExit(f'No encuentro {LIB}. Ejecutalo desde la raiz del proyecto Flutter.')

# El nombre del paquete, para resolver los import 'package:xxx/...'
PUBSPEC = RAIZ / 'pubspec.yaml'
paquete = 'normativas_app'
if PUBSPEC.is_file():
    m = re.search(r'(?m)^name:\s*(\S+)', PUBSPEC.read_text(encoding='utf-8'))
    if m:
        paquete = m.group(1)

# Una directiva va de la palabra clave al punto y coma; dentro puede haber
# varias cadenas (los import condicionales llevan mas de una ruta).
DIRECTIVA = re.compile(r'\b(?:import|export|part)\b[^;]*;', re.DOTALL)
CADENA = re.compile(r"""['"]([^'"]+\.dart)['"]""")


def sin_comentarios(texto: str) -> str:
    """El codigo de verdad, sin comentarios.

    Importa para las dos cosas que hace este script: un import comentado no
    es un uso, y el nombre de un archivo citado de pasada en un comentario
    tampoco. Antes marcaba como sospechosos archivos que solo aparecian en
    una linea comentada.
    """
    texto = re.sub(r'/\*.*?\*/', '', texto, flags=re.DOTALL)
    return re.sub(r'(?m)//.*$', '', texto)


def destinos(archivo: Path) -> set[Path]:
    """Las rutas .dart a las que apunta este archivo, ya resueltas."""
    try:
        texto = sin_comentarios(archivo.read_text(encoding='utf-8', errors='replace'))
    except OSError:
        return set()

    salida = set()
    for d in DIRECTIVA.findall(texto):
        for ruta in CADENA.findall(d):
            if ruta.startswith('dart:'):
                continue
            if ruta.startswith(f'package:{paquete}/'):
                destino = LIB / ruta[len(f'package:{paquete}/'):]
            elif ruta.startswith('package:'):
                continue                      # dependencia externa
            else:
                destino = (archivo.parent / ruta).resolve()
            salida.add(destino)
    return salida


todos = {p.resolve() for p in LIB.rglob('*.dart')}
inicio = (LIB / 'main.dart').resolve()
if inicio not in todos:
    raise SystemExit('No encuentro lib/main.dart')

# Recorrido en anchura desde main.dart
alcanzados, pendientes = {inicio}, [inicio]
aristas: dict[Path, set[Path]] = {}
while pendientes:
    actual = pendientes.pop()
    hijos = destinos(actual)
    aristas[actual] = hijos
    for h in hijos:
        if h in todos and h not in alcanzados:
            alcanzados.add(h)
            pendientes.append(h)

huerfanos = sorted(todos - alcanzados)

# Quien importa a quien, solo entre huerfanos, para ver los subarboles
for h in huerfanos:
    aristas.setdefault(h, destinos(h))

# Un huerfano citado fuera de un import merece una mirada
texto_todo = {}
for p in list(todos) + ([q.resolve() for q in TEST.rglob('*.dart')] if TEST.is_dir() else []):
    try:
        texto_todo[p] = p.read_text(encoding='utf-8', errors='replace')
    except OSError:
        pass

print(f'Proyecto: {RAIZ}')
print(f'Paquete:  {paquete}')
print(f'Archivos en lib/: {len(todos)} · alcanzados desde main.dart: {len(alcanzados)} · '
      f'huerfanos: {len(huerfanos)}\n')

if not huerfanos:
    print('No hay archivos sueltos: todo lib/ cuelga de main.dart.')
    raise SystemExit

print('=' * 78)
print('HUERFANOS  (ningun camino de imports llega a ellos desde main.dart)')
print('=' * 78)
for h in huerfanos:
    rel = h.relative_to(RAIZ)
    kb = h.stat().st_size / 1024
    lineas = texto_todo.get(h, '').count('\n') + 1

    # Quien lo menciona. Se separa el codigo de los comentarios: una cita
    # en codigo puede ser un uso que este analisis no ve (algo resuelto en
    # ejecucion); una cita en un comentario no es nada, pero se reporta por
    # si da contexto.
    patron = re.compile(rf'\b{re.escape(h.stem)}\b')
    en_codigo, en_comentario = [], []
    for p, t in texto_todo.items():
        if p == h:
            continue
        codigo = sin_comentarios(t)
        if patron.search(codigo):
            en_codigo.append(p)
        elif patron.search(t):
            en_comentario.append(p)

    vivas = [c for c in en_codigo if c in alcanzados]
    de_test = [c for c in en_codigo if TEST.is_dir() and TEST in c.parents]

    marca = ''
    if vivas:
        marca = '  <-- CUIDADO: lo nombra el codigo de un archivo vivo'
    elif de_test:
        marca = '  <-- solo lo usan las pruebas'

    print(f'\n  {rel}{marca}')
    print(f'      {kb:6.1f} KB · {lineas} lineas')
    hijos_h = sorted(x for x in aristas.get(h, set()) if x in todos)
    if hijos_h:
        print('      importa: ' + ', '.join(str(x.relative_to(LIB)) for x in hijos_h))
    for c in vivas:
        print(f'      nombrado en: {c.relative_to(RAIZ)}')
    for c in de_test:
        print(f'      usado por prueba: {c.relative_to(RAIZ)}')
    for c in en_comentario:
        print(f'      solo citado en un comentario de: {c.relative_to(RAIZ)}')

suelto = sum(h.stat().st_size for h in huerfanos) / 1024
print(f'\n{"=" * 78}')
print(f'Total: {len(huerfanos)} archivos, {suelto:.1f} KB')
print('\nAntes de borrar: mira los marcados con CUIDADO, y despues de borrar')
print('ejecuta `flutter analyze` para confirmar que no falta nada.')