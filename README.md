# Calculadora con ANTLR David Castellanos

En este caso se implementó una calculadora usando ANTLR (capítulo 4 del libro).  
Acá lo que pasa es que se definen las gramáticas que describen las expresiones y luego se generan el lexer y el parser con ANTLR. Después se usa un visitor para evaluar las expresiones.

## Qué contiene

- `LabeledExpr.g4` — gramática base con funciones (`sin`, `cos`, `tan`, `sqrt`, `ln`, `log`), unidades (`deg`/`rad`) y operador postfix `!`.
- `CalcOriginal.g4` — gramática con precedencia y asociatividad estándar.
- `CalcRedesign.g4` — gramática con precedencia y asociatividad modificadas para comparar resultados.
- Java:
  - `EvalVisitorOriginal.java`, `CalcOriginalDriver.java`
  - `EvalVisitorRedesign.java`, `CalcRedesignDriver.java`
- Python:
  - `eval_visitor.py`, `calc_py.py`
- `pruebas.txt`, `input.txt` — ejemplos y pruebas.
- `instalar_ejecutar.sh` — script con los comandos usados en Ubuntu.
- `.gitignore`

## Explicación

Cuando usamos ANTLR se escribe la gramática que describe el lenguaje (aquí, expresiones matemáticas).  
Acá lo que pasa es que, dependiendo de cómo se organicen las reglas de la gramática, cambian la precedencia y la asociatividad de los operadores. Eso hace que la misma cadena se pueda evaluar de forma distinta.

### Gramática original
- Comportamiento: `*` y `/` tienen mayor precedencia que `+` y `-`.  
- La potencia `^` en la versión original está definida con asociatividad izquierda (por ejemplo, `2^3^2` se interpreta como `(2^3)^2`).  
- El factorial `!` es operador postfix con máxima prioridad.  
Cuando usamos esta gramática, expresiones como `2+3*4` se interpretan como `2 + (3*4)`.

### Gramática rediseñada
- Comportamiento modificado: `+` tiene mayor precedencia que `*` y la potencia `^` queda con asociatividad derecha (por ejemplo, `2^3^2` se interpreta como `2^(3^2)`).  
- El objetivo es mostrar cómo cambian los resultados al cambiar la gramática.  
Cuando usamos esta gramática, `2+3*4` se interpreta como `(2+3)*4`.

## Comandos (Ubuntu)

Descargar ANTLR:
```bash
sudo mkdir -p /usr/local/lib
sudo wget -O /usr/local/lib/antlr-4.13.1-complete.jar https://www.antlr.org/download/antlr-4.13.1-complete.jar
```

Generar parser/visitor para la gramática original:
```bash
java -jar /usr/local/lib/antlr-4.13.1-complete.jar -visitor CalcOriginal.g4
javac *.java
```

Generar parser/visitor para la gramática rediseñada:
```bash
java -jar /usr/local/lib/antlr-4.13.1-complete.jar -visitor CalcRedesign.g4
javac *.java
```

Ejecutar pruebas con Java:
```bash
java CalcOriginalDriver pruebas.txt
java CalcRedesignDriver pruebas.txt
```

Generar versión Python y ejecutar:
```bash
java -jar /usr/local/lib/antlr-4.13.1-complete.jar -Dlanguage=Python3 -visitor CalcOriginal.g4
pip3 install --user antlr4-python3-runtime
python3 calc_py.py pruebas.txt
```

## Pruebas usadas

Archivo `pruebas.txt`:
```
2^3^2
10-3-2
2+3*4
5!^2
2^3*4
```

Resultados observados (resumen):

- Gramática original:
  - `2^3^2` → `(2^3)^2 = 64`
  - `10-3-2` → `(10-3)-2 = 5`
  - `2+3*4` → `2 + (3*4) = 14`
  - `5!^2` → `5! = 120`, `120^2 = 14400`
  - `2^3*4` → `(2^3) * 4 = 32`

- Gramática rediseñada:
  - `2^3^2` → `2^(3^2) = 512`
  - `10-3-2` → `10 - (3 - 2) = 9`
  - `2+3*4` → `(2 + 3) * 4 = 20`
  - `5!^2` → `14400`
  - `2^3*4` → `32`

## Notas técnicas

- Factorial `!` implementado para enteros no-negativos. Si se pasa un real se convierte por floor antes de calcular.
- Validaciones básicas: `sqrt(x)` con `x >= 0`, `ln(x)` y `log(x)` con `x > 0`.
- Los visitors en Java usan recursión para procesar las secuencias de operadores y el factorial (no usan bucles explícitos).

## Archivos principales

- `CalcOriginal.g4`, `CalcRedesign.g4` — gramáticas para comparar.
- `EvalVisitorOriginal.java`, `EvalVisitorRedesign.java` — visitors Java.
- `CalcOriginalDriver.java`, `CalcRedesignDriver.java` — drivers Java.
- `eval_visitor.py`, `calc_py.py` — versión Python.
- `pruebas.txt`, `input.txt` — ejemplos.

