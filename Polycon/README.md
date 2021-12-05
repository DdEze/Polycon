# TPI 3

## Rails y Gemas

La aplicación rails para el tpi 3 se encuntra en el directorio Polycon, y la gemas que e usado para esta entrega son:

    1. Devise: Para la implementación de autentificación de usuario que ingrese al sistema.
       
    2. Cancancan: Para crear los permiso de los distintos tipos de roles de los usuarios.
       
    3. Will_paginate: Para la paginacón y restringir la cantidad de información que se muestran en la vista, para los profesionales, turno y usuario.
       
    4. Bootstrap: Para la personalización de las distintas vistas.
       
    5. Validates_timeliness: Para la validación de fechas.

## Interacción con el usuario

Para ver los profesionales y turno uno primero debe iniciar sesión con una cuenta ya registrada o crear un nuevo usuario, este por defecto se creara con el rol de consulta.

Una vez que se inicio la sesión se vera todos los profesionales del sistema donde según los permiso del rol, se podrá crear, ver, eliminar, editar y ver los turnos de un profesional en particular, también se podrá generar una grilla de un día o semana de una fecha en particular de todo los turnos que se encuentre en la base de datos.

Si se mira los turnos de un profesional se podrá según los permiso del rol, crear, ver, eliminar y editar un turno en particular del profesional, también se podrá eliminar todos sus turnos o generar grilla de los turno del profesional por día o semanal de una fecha en particular que se encuentre en la base de datos.

Las grillas tanto por profesional o en general se descargar en formato html, y los horarios para crear un turno son de 8 a 21 en la horas puntuales o en la media hora.

En la navegación todos los roles podrán ir al inicio haciendo click en profesionales y en su email podrá cambiar la contraseña o eliminar su cuenta y el rol de administración adicionalmente puede en usuarios gestionar a los de más usuario cambiando su ro.

## Base de Datos

Para la base de datos decidí utilizar SQlite, y cargado en la seed se encuentran tres usuario con distintos roles.

La cuentas son: usuario

    1. Para el de administración email: admin@gmail.com y contraseña: admin123.

    2. Para el de consulta email: consul@gmail.com y contraseña: consul123.
     
    3. Para el de asistencia email: asis@gmail.com y contraseña: asis123.

Ademas de los usuario también se encuentran cargados varios profesionales y turnos.


