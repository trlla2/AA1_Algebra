- Nombres completos de integrantes del equipo
Roc Allue Canut y Guillem Fernández López


- Explicación del juego (funcionalidades, decisiones tomadas, etc)
El juego trata de un PJ que tiene que ir recogiendo a sus mascotas para acabar con los enemigos mientras coge los power ups 
o downs que modifican sus caracteristicas. Al recoger los 3 power ups se pasara por un portal para pooder derrotar al BOSS.

Las mascotas siempre iran hacia ti, apartandose un poco de ti para no llegar a colisionar. Tanto ellas como el PJ se chocan 
con los muros y no pueden pasar a traves de ellos, y la mascota 2, que es la que tiene vida, se le quita vida en colision
con los muros. 

Los power Ups y Downs son los siguientes:
Power Ups: aumenta el tamaño del PJ, disminuye el tamaño de las mascotas, aumenta la velocidad las mascotas.
Power Downs: Disminuye el tamaño del PJ, aumenta el tamaño de las mascotas, disminuye la velocidad de las mascotas.

En la batalla del boss, se ha optado por que la mascota 1 haga daño al boss y que la mascota 2 sirba como "target" 
del mismo, asi teniendo que defender a tu mascota 2 del Boss junto con tu mascota 1.

La vida del PJ va unida a la de la mascota 2, que tienes que ir a recogerla a un punto random del mapa para que te empiece a 
seguir y aparezcan los power Ups. La mascota 2 tiene 3 vidas, y cada vez que pierda 3 vidas se le quitara una vida al PJ.
La mascota volvera a tener 3 de vida y asi sucesivamente hasta que el PJ se quede sin vidas.

Si se llega a 60 segundos, el PJ pierde una vida, pero el juego continua.

En el modo teclado se ha hecho que el PJ no pueda sobresalir de la pantalla para que no lo pierdas de vista.


- Instrucciones para jugar (menús, teclas, etc)
Primero de todo, en el lector de texto de el numero de enemigos que aparece nada mas empezar el juego, NO se pueden poner letras.

Se ha optado por un estilo de botones para elegir el tipo de control que tienes sobre el PJ, o mouse o teclado.

Para la opcion de mouse se mueve con el raton, y el PJ sigue a tu raton, y en la opcion de teclado, se mueve el PJ con las
flechas direccionales. El PJ, en el caso de que sea en teclado, aparece en el centro de la pantalla.

Una vez elegido el control y el numero de enemigos, para empezar, se le da a Start, el boton grande que hay arriba a la izquierda.

A partir de aqui se hace lo mencionado anteriormente para poder derrotar al boss y acabar el juego.


- Librerías que se han empleado, que hay que incluir y para qué
ControlP5, que se ha utilizado para hacer la UI del menu y los botones.

La fuente que hay dentro de la carpeta no hace falta instalarla. La lee el programa directamente.

- Descripción concreta de lo que ha hecho cada persona del equipo
Roc: Movimiento del PJ, colisiones (obstaculos), UI (Barras de vida, UI menu, timers, scores...), Sistema de escenas (Menu, Gameplay, Boss Fight, Win y Lose).

Guillem: Comportamiento de los enemigos (pathfinding, dibujo, hp, daño...), comportamiento para las mascotas (pathfinding, dibujo, hp, daño...),
colisiones enemigos y mascotas, Boss Fight

Estas son las tareas que hemos hecho generalmente cada uno, pero despues nos hemos ayudado mutuamente a hacerlas.


- Postmortem (reflexión crítica post proyecto):
-- Lo que SI ha ido bien
Ha habido muy buena comunicacion, los momentos de trabajo han sido muy productivos estando en llamada en todo momento del proyecto,
ha habido ayuda por los dos bandos.

-- Lo que NO tanto y podemos mejorar
Habernos puesto a trabajar antes, hemos procastinado un poco, lo que ha afectado a la calidad del codigo y no haber podido hacer
mejoras para el proyecto, cosa que se solucionara en siguientes proyectos.