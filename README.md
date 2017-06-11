# an-metri-gal
Análise métrico de texto en verso en lingua galega (Galician language) gl-ES

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [an-metri-gal](#an-metri-gal)
	- [Overview - Introducción](#overview-introduccin)
		- [Objetivos.](#objetivos)
		- [Notas en la implementación.](#notas-en-la-implementacin)
		- [Ejemplos de ejecución.](#ejemplos-de-ejecucin)
		- [Observaciones.](#observaciones)
	- [Copyright](#copyright)
	- [Build](#build)
	- [Documentation](#documentation)
	- [Aviso / Warning](#aviso-warning)

<!-- /TOC -->
## Overview - Introducción

El nombre de este proyecto es `an-metri-gal`, “análisis de texto en verso en gallego” o "análisis de métrica en gallego", lo cual indica que se centrará no en los problemas de semántica y/o extracción de conocimiento del lenguaje natural sino en la métrica y la rítmica de
un conjunto de versos.

El verso, que será la unidad fundamental, estará agrupado en estrofas y dividido en sílabas.

Ha de notarse que este __analizador de texto en verso es factible para gallego y español, no siendo posible para otras lenguas como el inglés o el francés, al menos utilizando esta técnica ya que no hay una correspondencia tan directa entre conjuntos de grafemas (sílabas
escritas) y unidades de entonación__.

Estrictamente, para realizar un análisis totalmente completo del texto en verso, deberían considerarse sus unidades reales como son los fonemas y las unidades de entonación, siendo para ello necesario definir una
notación nueva y completa, ya que la propia lectura o interpretación de un verso deja a veces al criterio subjetivo del lector donde enfatizar el acento rítmico o pausar un verso deshaciendo sinalefas o diptongos o
uniendo un hiato.

Esta situación se agrava con el verso libre, donde el posible esquema no nos guía para la elección de un esquema de entonación dentro del verso.

Me parece bastante claro que con la mera escritura de un verso y usando técnicas convencionales el análisis de un poema incluso en las propicias lenguas gallega o española no deja de ser una aproximación.

Para un análisis más profundo y general sería necesario disponer de una notación suplementaria que debería usar el autor (similar a la musical).

Por último recordar que el poema no contiene sólo métrica sino también ritmo, entonación, recursos literarios, por lo cual, como se explicita en los objetivos, el análisis que contempla esta práctica es un subconjunto del complejísimo análisis que sería resultado de tener en cuenta el autor, el tema, las circunstancias del poema, las influencias,
el idioma, etc.

### Objetivos.

El objetivo de esta práctica es identificar estructuras de estrofas clásicas en poemas contenidos en ficheros de texto.

Los poemas tendrán una mínima notación adicional:

-   Antes de la última vocal tónica de cada verso se pondrá un símbolo `#`.

-   Entre cada estrofa, como separador, se intercalará un símbolo `@`” (no al principio o fin del fichero).

Como se aprecia es una notación mínima que no interfiere en el proceso de creación literaria.

Este objetivo de identificación que parece fácilmente alcanzable en un primer vistazo del problema no lo es tanto al observar los subobjetivos necesarios:

-   Contado de sílabas. Para ello es necesario tener en cuenta.

-   Hiatos.

-   Diptongos.

-   Tonicidad de la última palabra del verso.

-   Licencias métricas (sinalefas, etc.)

-   Rima.

-   Obtención de la estructura de la estrofa analizada.

-   Teniendo en cuenta la rima.

-   Teniendo en cuenta el arte (mayor o menor) de cada verso.

-   Comparación de la estructura encontrada con las estructuras de estrofa almacenadas.

-   Teniendo en cuenta versos libres, etc.

Estos subobjetivos se han ido consiguiendo en la implementación aproximadamente en el orden descrito anteriormente.

### Notas en la implementación.

Esta práctica ha sido implementada en el lenguaje funcional __Ocaml__, inicialmente en la versión 2.02 y posteriormente migrada a la versión 4.02.3.

En primer lugar es necesario hacer notar que fue necesaria la
implementación de una clase cadenaISO.ml usando las características de orientación a objetos de Ocaml para tener una interfaz regular para el tratamiento de strings que contienen caracteres con tilde y otros símbolos, ya que para Ocaml, esos caracteres especiales están constituídos dentro de un string por dos posiciones, lo que complicaba sobremanera la implementación ya que Ocaml no los trataba como caracteres individuales.

En segundo lugar se puede destacar la no utilización de `ocamllex`  u `ocamlyacc` para esta implementación ya que la estrategia que era necesaria implementar para el contado de sílabas era totalmente distinta a la que usa ocamllex o flex. La estrategia en una primera aproximación era moverse hasta la siguiente vocal, y todas las consonantes anteriores
a ella no asignadas a la sílaba anterior, debían pertenecer a la actual.
Esta estrategia la probé pero necesitaba hacer cada vez una “vuelta atrás para mirar lo que queda”.

Después de probar con otras formas, también ineficientes y fallidas, se me ocurrió darle la vuelta al string y separar las sílabas de esta forma; esta vez la idea tuvo éxito, ya que de esta forma nunca hay que “mirar atrás”, siempre hacia adelante.

En tercer lugar también se puede mencionar que aunque seguramente que se podía hacer de una forma puramente funcional, la implementación del separador de sílabas (función `analiza` en el módulo *utiles.ml*) contiene elementos de programación procedural admitidos por Ocaml.

Por último, he de mencionar que el conjunto de estrofas reconocidas por el programa se puede ampliar fácilmente ya que, como se puede ver en el módulo *esquemas.ml*, los esquemas de las estrofas reconocibles se introducen en una tabla Hash cuya clave es el número de versos de la estrofa y la información allí contenida es una lista con todas las
estrofas reconocibles con ese número de versos, cada una de las cuales tiene el formato `(Nombre_estrofa , esquema , tipo_rima (“AS” | ”CO”))`.

A causa de esto pueden contemplarse estrofas como el quinteto o la quintilla que no tienen un esquema fijo, sino que puede ajustarse a varios, serán todos ellos identificados como Quinteto o quintilla.

### Ejemplos de ejecución.

En primer lugar se ha compilar el programa, esto se consigue haciendo simplemente `make` en el directorio donde se encuentren los ficheros del programa. Este comando crea un ejecutable llamado `poe`.

El formato de uso, que el propio ejecutable muestra al usarlo
incorrectamente, es:

```
$ poe fich_entrada fich_salida
```

donde `fich_entrada` es el fichero que se desea analizar en el formato citado y `fich_salida` es el nombre del fichero donde se desea grabar la salida del programa.

### Observaciones.

Evidentemente los ejemplos propuestos no son un prueba exhaustiva del programa, pero ha de hacer notarse la tolerancia del mismo a un pequeño fallo en el contado de las sílabas, ya que al crear el esquema de la estrofa analizada antes de compararlo con los esquemas reconocibles, aún
en caso de no poder identificar la estrofa nos enseña a valiosa información de que tipo de rima emplea y el esquema de esa estrofa.

He de señalar que los esquemas de las estrofas siguen la notación habitual en los libros elementales sobre métrica poética:

-   Si el verso es de arte menor la letra asignada será minúscula, si es de arte mayor, mayúscula.

-   Si un verso `i` rima con otro verso `j` que tiene asignada la letra `x`, al verso `i` se le asignará la letra `x` ó `X`, dependiendo de si es de arte mayor o menor.

-   Los versos que no riman con ninguno en la estrofa se denotan en el esquema por el guión `-`.

Ha de notarse en los ejemplos probados el caso de `son.txt` y
`son2.txt`, el mismo soneto se le presenta en el primer caso como 4 estrofas separadas y las indentifica correctamente como 2 serventesios y 2 tercetos; en el segundo caso se le presenta sin separar, como una sola estrofa, en este caso lo identifica también correctamente como un soneto.

Asimismo puede destacarse que aunque el analizador ha sido pensado para versos en gallego (no contempla la letra `y` como una consonate válida, etc.) funciona aceptablemente bien en versos en español como los de Antonio Machado del “Cancionero apócrifo” que se prueban.


## Copyright
1999 - 2017 Julio José Gómez Díaz

## Build
  - Compiler: Ocaml 4.02.3 x86_64 Cygwin (Windows)
  - Build tool: GNU make 4.2.1 x86_64 Cygwin (Windows)
Se puede
## Documentation

TO-DO

## Aviso / Warning
Todo o contido deste repositorio debe utilizarse de acordo coa licencia contida no ficheiro 'LICENSE'.

Every file in this repositorio must be used in accordance with license inside 'LICENSE' file.

Todo el contenido de este repositorio debe utilizarse de acuerdo con la licencia contenida en el fichero 'LICENSE'.
