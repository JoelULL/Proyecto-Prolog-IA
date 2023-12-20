/* Wendigo -- Un simple juego de aventuras. 
   Desarrollado por: Joel Aday Dorta Hernández.
   
   Nota: ejecutar en un entorno como VScode para su correcto funcionamiento.
   La página del profesor del aula virtual presenta errores en su ejecución.
   Comando para iniciar el programa: swipl -s historia_proyecto.pl
   Comando para iniciar:   start.  */

/* Definicion de predicados dinámicos, aquellos que pueden ser modificados durante la ejecución. 
   Tambien se utilia retractall para eliminar todas las cláusulas que coincidan con el patrón 
   especificado eliminando cualquier hecho relacionado con esos predicados.*/
:- dynamic en/2, estoy_en/1, vive/1.  
:- retractall(en(_, _)), retractall(estoy_en(_)), retractall(vive(_)).

/* Define el lugar en el que se encuentra el jugador. */
estoy_en(exterior).

/* Los siguientes hechos describen como están interconectados los lugares transitables entre sí. */
camino(wendigo, d, habitacion).
camino(habitacion, u, wendigo).

/* Camino con una toma de deciciones incluida con tres posibilidades, solo una correcta*/
:- dynamic(accion_realizada/1).
:- discontiguous camino/3.
camino(habitacion, w, escaleras) :- en(cizallas, en_mano),
 \+ accion_realizada(esquivar_wendigo),
    write('Escuchas un alarido y parece que algo viene corriendo por el pasillo!'), nl,
    write('a. Te escondes detrás de una estantería aguantando la respiración.'), nl,
    write('b. Te enfrentas a lo que sea que venga con tu cuchillo.'), nl,
    write('c. Intentas huir corriendo.'), nl,
    read(Respuesta),
    validar_respuesta(Respuesta).

validar_respuesta(a) :-
    asserta(accion_realizada(esquivar_wendigo)),
    write('Has conseguido esquivar al wendigo!'), nl.

validar_respuesta(b) :-
    write('El wendigo te tira el cuchillo de un zarpazo y acaba contigo'), nl, !, morir.

validar_respuesta(c) :-
    write('Era un wendigo! corre más rápido que tú y te atrapa.'), nl, !, morir.

validar_respuesta(_) :-
    write('Opción no válida. Por favor, selecciona una opción válida.'), nl,
    camino(habitacion, w, escaleras).
camino(habitacion, w, escaleras).

camino(escaleras, e, habitacion).
camino(escaleras, n, planta_baja).

camino(planta_baja, s, escaleras) :- en(linterna, en_mano).
camino(planta_baja, s, escaleras) :-
        write('Subir ahí sin luz?  Ni de broma.'), nl,
        !, fail.
camino(planta_baja, n, exterior).
camino(planta_baja, w, atrapado).

camino(atrapado, e, planta_baja).

camino(cocina, w, planta_baja).

camino(planta_baja, e, cocina) :- en(llaves, en_mano).
camino(planta_baja, e, cocina) :-
        write('La puerta esta cerrada con llave. Tiene un agujero, puedo ver un cuchillo de cocina!'), nl,
        fail.

camino(exterior, s, planta_baja).

/* Aquí se definen los lugares en los que se podrá obtener los diferentes objetos. */

en(cizallas, wendigo).
en(llaves, escaleras).
en(linterna, atrapado).
en(cuchillo, cocina).


/* Este hecho especifica la supervivencia del wendigo*/

vive(wendigo).


/* Reglas que describen como coger un objeto. */

coger(X) :-
        en(X, en_mano),
        write('Eso ya lo tengo!'),
        nl, !.

coger(X) :-
        estoy_en(Lugar),
        en(X, Lugar),
        retract(en(X, Lugar)),
        assert(en(X, en_mano)),
        write('Lo tengo. '),
        descripcion_objeto(X),
        nl, !.

coger(_) :-
        write('No veo nada útil aquí.'),
        nl.


/* Estas reglas describen como soltar un objeto. Con las posibilidades posibles. */

soltar(X) :-
        en(X, en_mano),
        estoy_en(Lugar),
        retract(en(X, en_mano)),
        assert(en(X, Lugar)),
        write('Lo he soltado.'),
        nl, !.

soltar(_) :-
        write('No lo llevas encima!'),
        nl.


/*ver inventario.*/

inventario :-
findall(X, en(X, en_mano), Inventario),
(Inventario == [] ->
write('No tienes ningun objeto en tu inventario'), nl;
write('Tu inventario es: '), nl,
write(Inventario), nl
).

/* Estas reglas definen las seis direcciones a las que se puede ir */
/*n: norte; s: sur; e: este; w: oeste(west); u: arriba(up); d: abajo(down)*/
n :- ir(n). 

s :- ir(s).

e :- ir(e).

w :- ir(w).

u :- ir(u).

d :- ir(d).


/* Esta regla define como moverse en una dirección determinada*/

ir(Direccion) :-
        estoy_en(Aqui),
        camino(Aqui, Direccion, Alli),
        retract(estoy_en(Aqui)),
        assert(estoy_en(Alli)),
        observar, !.

ir(_) :-
        write('No puedes ir en esta direccion.').


/* Esta regla permite al usuario volver a observar a su alrededor para comprobar donde se encuentra*/

observar :-
        estoy_en(Lugar),
        describe(Lugar),
        nl,
        encontrar_objetos_en(Lugar),
        nl.


/* Esta regla permite mostrar al usuario cual o cuales son los objetos que tiene cerca. */

encontrar_objetos_en(Lugar) :-
        en(X, Lugar),
        write('Parece que hay un/una '), write(X), write(' aquí.'), nl,
        fail.

encontrar_objetos_en(_).


/* En estas reglas se definen las variables de utilizar la accion de matar. */

matar :-
        estoy_en(atrapado),
        write('El wendigo te agarró una pierna! Has muerto por el wendigo atrapado.'), nl,
        !, morir.

matar :-
        estoy_en(habitacion),
        write('Eso no va a funcionar. quizá'), nl,
        write(' si lo pillo por sorpresa...').

matar :-
        estoy_en(wendigo),
        en(cuchillo, en_mano),
        retract(vive(wendigo)),
        write('Saltas hacia la espalda del wendigo y consigues apuñalarlo en el cuello. '), nl,
        write('cae a plomo con un grito ahogado.'), nl,
        write('Creo que lo has matado, buen trabajo.'),
        nl, !.

matar :-
        estoy_en(wendigo),
        write('Intentar golpear al wendigo con tus puños te costó caro.'), nl,
        write('El wendigo te despedaza.'), nl, !, morir.

matar :-
        write('No veo nada peligroso aquí.'), nl.


/* Esta regla muestra el mensaje de muerte y termina el juego. */

morir :-
        !, finish.


/* Esta regla ocurre cuando el jugador gana o pierde en el juego */

finish :-
        nl,
        write('Fin del juego.'),
        nl, !,
        halt.


/* Esta regla muestra las instrucciones de juego al usuario. */

instrucciones :-
        nl,
        write('Escribe estos comandos usando la sintaxis estandar de Prolog.'), nl,
        write('Los comandos disponibles son:'), nl,
        write('start.                   -- Para empezar el juego.'), nl,
        write('n.  s.  e.  w.  u.  d.   -- Para ir en esa direccion: norte,sur,este,oeste,arriba,abajo.'), nl,
        write('coger(Object).           -- Para recoger un objeto.'), nl,
        write('soltar(Object).          -- Para tirar un objeto.'), nl,
        write('inventario.              -- mostrar inventario.'), nl,
        write('matar.                   -- Para atacar un enemigo.'), nl,
        write('observar.                -- Para mirar de nuevo a tu alrededor.'), nl,
        write('instrucciones.           -- Para ver las instrucciones.'), nl,
        write('halt.                    -- Para cerrar el juego.'), nl,
        nl.


/* Esta regla permite inicializar el juego muestra al jugador las instrucciones y da una descripcion
   de donde se encuentra. */

start :-
        instrucciones,
        observar.



/* Estas reglas describen las diferentes habitaciones disponibles. Dependiendo de las circustancias,
   una habitación puede tener más de una descripción.*/
describe(exterior) :-
        en(cizallas, en_mano),
        write('Felicidades!!  Has roto el candado y has podido escapar.'), nl,
        write('Has ganado el juego.'), nl,
        finish, !.

describe(exterior) :-
        write('Estas en el jardín de una casa antigua.'), nl,
        write('La puerta principal del jardín tiene un candado oxidado, parece que se puede romper con algo.'), nl,
        write('El muro es demasiado alto para poder saltarlo. Hacia el sur está la entrada de la casa.'), nl,
        write('Debes encontrar algo para poder romper el candado y escapar.'), nl.

describe(planta_baja) :-
        write('Estas en una casa antigua, entra algo de luz de la luna por la ventana. La salida esta detras de ti, hacia el norte.'), nl,
        write('Hay una pequeña habitacion hacia el oeste, la puerta se mueve'), nl,
        write('sola con el viento.  Hay otra puerta hacia el este.'), nl,
        write('Hacia el sur se alzan unas escaleras oscuras hacia la planta alta'), nl.
        

describe(atrapado) :-
        write('Hay un wendigo atrapado bajo unos escombros!  El wendigo araña el suelo'), nl,
        write('y te observa de forma desafiante.  Mejor salir de aquí!'), nl,
        write('Puedo volver por el este.'), nl.

describe(cocina) :-
        write('Esto es una cocina antigua, no se puede escapar por aquí.'), nl,
        write(' Puedo volver por el oeste.'), nl.

describe(escaleras) :-
        write('Has subido las oscuras escaleras. La salida esta hacia'), nl,
        write('el norte; Hay un largo y oscuro pasillo hacia'), nl,
        write('el este.'), nl.

describe(habitacion) :-
        vive(wendigo),
        en(cizallas, en_mano),
        write('El wendigo te ve con las cizallas y te ataca!!!'), nl,
        write('    ...mueres en un instante...'), nl,
        morir.

describe(habitacion) :-
        vive(wendigo),
        write('Hay un gran wendigo aquí!  Parece que no te'), nl,
        write('ha visto, está de espaldas hacia a ti!'), nl,
        write('Quiza si te subes encima podrías acabar con él...'),
        write('Lo mejor sería salir de aquí por el oeste sin hacer ruido....'), nl, !.
describe(habitacion) :-
        write('Oof!  Hay un wendigo muerto aquí!'), nl.

describe(wendigo) :-
        vive(wendigo),
        write('Te acercas al wendigo preparado para saltar sobre el,'), nl,
        write('Parece que delante suyo hay algo...'), nl.

describe(wendigo) :-
        write('Lo has conseguido! Has saltado sobre el wendigo y lo has matado!'), nl.

descripcion_objeto(llaves):-
write('Son unas llaves antiguas, con un diseño peculiar, podrían servir para abrir la cocina!'),nl.
descripcion_objeto(linterna):-
write('Una linterna... No parece muy antigua, me pregunto que le habrá pasado a su dueño.'),nl.
descripcion_objeto(cuchillo):-
write('Un viejo pero afilado cuchillo de cocina! Quizá podría defenderme con esto.'),nl.
descripcion_objeto(llaves):-
write('Son unas llaves antiguas, con un diseño peculiar, podrían servir para abrir la cocina!'),nl.
descripcion_objeto(cizallas):-
write('Unas cizallas! Con esto podré romper el candado y escapar.'),nl.