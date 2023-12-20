# Proyecto de prolog de la asignatura de Inteligencia Artificial
* * *
## Descripción del juego
El juego Wendigo es una aventura interactiva implementada en el lenguaje deprogramación lógico Prolog. El objetivo principal es escapar de una casa antiguaenfrentando al jugador a una serie de desafíos y tomando decisiones estratégicas para sobrevivir.
El juego se desarrolla en un entorno de texto donde el usuario puede moverse entre distintos escenarios, interactuar con objetos y enfrentarse a una serie de desafíos como es el Wendigo, el principal antagonista del juego. El jugador tiene el objetivo de escapar de la casa resolviendo acertijos, recogiendo objetos útiles que le permitirán avanzar en la historia y evitar al Wendigo
### Modo de ejecución
Escribir en la terminal el siguiente comando:
```
  swipl -s historia_proyecto.pl
```
Una vez hecho esto escribir el comando **start.** para empezar el juego. Al usuario se le mostrará unas instrucciones que lo guiarán durante el juego.
### Otras consideraciones
Si no se tiene instalado el SWIPL puede instalarse mediante el siguiente comando en la terminal:
```
  sudo apt-get install swi-prolog
```
Para comprobar si está instalado previamente o simplemente para comprobar su versión podremos utilizar este comando:
```
  swipl --version
```

En caso de que se ejecute en **Windows** es recomendable añadir al comienzo del código la siguiente línea:
```
  :-encoding(utf8).
```
Esto hará que el texto mostrado por pantalla se muestre correctamente formateado haciendo que las tíldes y otros caracteres se muestren correctamente.
