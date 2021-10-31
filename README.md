# Polycon

Plantilla para comenzar con el Trabajo Práctico Integrador de la cursada 2021 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Polycon es una herramienta para gestionar los turnos y profesionales de un policonsultorio.

Este proyecto es simplemente una plantilla para comenzar a implementar la herramienta e
intenta proveer un punto de partida para el desarrollo, simplificando el _bootstrap_ del
proyecto que puede ser una tarea que consume mucho tiempo y conlleva la toma de algunas
decisiones que más adelante pueden tener efectos tanto positivos como negativos en el
proyecto.

## Uso de `polycon`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/polycon`,
el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/polycon [args]
```

O bien:

```bash
$ bundle exec bin/polycon [args]
```

O simplemente:

```bash
$ bin/polycon [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ polycon [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler. Para más información sobre la instalación de las dependencias, consultar la
> siguiente sección ("Desarrollo").

Documentar el uso para usuarios finales de la herramienta queda fuera del alcance de esta
plantilla y **se deja como una tarea para que realices en tu entrega**, pisando el contenido
de este archivo `README.md` o bien en uno nuevo. Ese archivo deberá contener cualquier
documentación necesaria para entender el funcionamiento y uso de la herramienta que hayas
implementado, junto con cualquier decisión de diseño del modelo de datos que consideres
necesario documentar.

## Desarrollo

Esta sección provee algunos tips para el desarrollo de tu entrega a partir de esta
plantilla.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes: ¡lo vamos a ver en breve en la materia! Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa (esto deberías hacerlo solamente
cuando estés comenzando con la utilización del proyecto), podés comenzar a probar la
herramienta y a desarrollar tu entrega.

### Estructura de la plantilla

El proyecto te provee una estructura inicial en la cual podés basarte para implementar tu
entrega. Esta estructura no es necesariamente rígida, pero tené en cuenta que modificarla
puede requerir algún trabajo adicional de tu parte.

* `lib/`: directorio que contiene todas las clases del modelo y de soporte para la ejecución
  del programa `bin/polycon`.
  * `lib/polycon.rb` es la declaración del namespace `Polycon`, y las directivas de carga
    de clases o módulos que estén contenidos directamente por éste (`autoload`).
  * `lib/polycon/` es el directorio que representa el namespace `Polycon`. Notá la convención
    de que el uso de un módulo como namespace se refleja en la estructura de archivos del
    proyecto como un directorio con el mismo nombre que el archivo `.rb` que define el módulo,
    pero sin la terminación `.rb`. Dentro de este directorio se ubicarán los elementos del
    proyecto que estén bajo el namespace `Polycon` - que, también por convención y para
    facilitar la organización, deberían ser todos. Es en este directorio donde deberías
    ubicar tus clases de modelo, módulos, clases de soporte, etc. Tené en cuenta que para
    que todo funcione correctamente, seguramente debas agregar nuevas directivas de carga en la
    definición del namespace `Polycon` (o dónde corresponda, según tus decisiones de diseño).
  * `lib/polycon/commands.rb` y `lib/polycon/commands/*.rb` son las definiciones de comandos
    de `dry-cli` que se utilizarán. En estos archivos es donde comenzarás a realizar la
    implementación de las operaciones en sí, que en esta plantilla están provistas como
    simples disparadores.
  * `lib/polycon/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).
* `bin/`: directorio donde reside cualquier archivo ejecutable, siendo el más notorio `polycon`
  que se utiliza como punto de entrada para el uso de la herramienta.

## Documentación

Para el formato del los nombres de directorios y archivos use el formato dicho por el enunciado del trabajo practico integrador, los directorios con los nombres de lo profesionales están guardados en el directorio .polycon en el directorio personal "Home". El formato para los nombre de los directorio de los profesionales seria el nombre del profesional y si el nombre lleva espacio de remplazara con un "_" por ejemplo: El directorio de la profesional Alma Estevez seria Alma_Esteves. Y para el nombre de los archivos para los turnos seria el siguiente formato de fecha: AAAA-MM-DD_HH-II.

### Módulos para la persistencia de profesionales y turnos

Para realizar los métodos para la persistencia e decidido crear dos clases y un módulos, un módulo para los métodos relacionado con las ruta de los directorios y archivos, una clase para los métodos relacionados con la gestión de los profesionales y la otra clase para los métodos relacionados con la gestión de turno.

Las clases que pertenecen tanto al módulo Professionals y Appointements utilizan las clase Professional y Appointment respectivamente.

#### Módulo para las ruta de directorios y archivos

Para devolver o preguntar por una ruta de un directorio o archivo cree un módulo llamado Patch que posee métodos que realizan dichas acciones.
 
Estos métodos utilizan la clases Dir que provee el lenguaje, para devolver la ruta del directorio use el método home de la clase Dir que devuelve el directorio "home" sumado al directorio /.polycon seguido del nombre del profesional. Y para preguntar si existe un directorio de un profesional use el método exist? que provee la clase Dir.

Para los archivo es algo parecido a lo hecho con los directorios, para devolver la ruta de un turno de un profesional, primero hay que devolver la ruta del directorio del profesional más el nombre del archivo que se quiera devolver. Y para preguntar si existe un archivo utilice el método exist? que provee la clase File.

Otro método que agregue a este modulo es un método que devuelve un mensaje si el directorio   .polycon no esta creado para guardar los directorios de los profesionales y si esta carpeta existe que realice la acciones requeridas.

#### Clase Professional para la gestión de los profesionales

Para la realización de los métodos para la gestión de profesionales, decidí que la clase Professional incluya el módulo Patch que contiene los métodos que devuelven y pregunta por la existencia de las rutas de los directorios de los profesionales.

Para para manipular y crear los directorios que representaría la persistencia de los profesionales utilice los métodos de la clase Dir y para borrar un directorio utlice el método rm_rf de la clase FileUtils.

#### Clase Appointment para la gestión de los turnos

Para la realización de los métodos para la gestión de turno, también hice que incluya el módulo que contiene los métodos que devuelven y preguntan por la existencia de los directorios y archivos.

Para editar y crear los archivos utilice el método open de la clase File, para borrar tanto un archivo o todos los archivos de un directorio utilice el método rm_rf de la clase FileUtils, esta clase también la utilice para el método que cambia el nombre de un archivo.

Otra clase que utilice en este modulo, es la clase DateTime, con ella parceo la fecha que viene como string a una clase Time. Esto lo utilizo para preguntar por la fecha para que no se pueda sacar un turno con una fecha pasada, también con esta clase tengo un método que me asegura que cuando llegue dos fechas iguales con formato diferente por parte del día como puede ser 2021-12-05 13:00 y 2021-12-5 13:00 pasen a un mismo formato que completa el día de la fecha si no es de dos dígitos con un cero adelante.

También en esta clase agregue métodos de validación que verifica, que la fecha o numero de teléfono ingresado por el usuario sea en realidad una fecha o un numero de teléfono.

### Corrección del TPI 1

Se corrigió el método reschedule de appointments que funcionaba mal y se cambiaron los puts, también corregí algunas validaciones que andaban mal y el método delete de professionals que no hacia realmente los que tenia que hacer, ahora elimina el profesional si no tiene turno, si tiene turno primero se tiene que cancelar los turnos y después borrar los turnos. Otra función que agrege es que si la carpeta .polycon no existe, cuando se intente hacer algun comando se cree esta carpeta.

### TPI 2

Para el TPI 2 agregue dos comandos nuevos para appointments, estos son: list_by_day y list_by_week.

list_by_day muestra una grilla de todos los turnos de un día en particular de un o de los profesionales, esta grilla contiene la información del horario del turno, la información del paciente y el profesional a que le corresponde el turno.

list_by_week muestra en una grilla todos los turnos de una semana en particular de un o de los profesionales, esta grilla contiene los horarios de los turno verticalmente (para los horarios decidí que los turnos solo se puedan sacar entre las 8 hasta la 20 y que solo se pueda sacar turno en una hora puntual o en la hora y media), y horizontalmente los días de la semana y el profesional del turno. En la grilla si existe el turno en la semana mostrara el nombre y apellido del paciente, si en la semana no tiene turno para un horario, en la grilla se mostrara "Sin turno".

La ambas grilla quedan guardadas en la carpeta "polycon_appointments.html" en la carpeta home, por lo tanto si se ejecuta uno de los dos comando sobrescribe lo que tenia antes.

Para hacer las grilla utilice el sistema de plantilla que proporciona la librería ERB, para la creación del documento html.



