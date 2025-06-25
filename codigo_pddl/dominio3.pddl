;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 3 - Práctica 3 TSI
; Elena Torres Fernández
; dominio3.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain ejercicio3)
    (:requirements :strips :typing :adl) ; adl para incluir or en las precondiciones
    (:types
        tipoPersonaje movible Localizacion - object
        Personaje Recurso - movible
    )
    (:constants
        Enano Hobbit Mago Elfo Humano - tipoPersonaje
        Mineral Mithril Madera Especia Alimento Anillo Espada - Recurso
    )
    (:predicates
        ; Determinar si un personaje o nodo de recurso está en una localización determinada
        (en ?obj - movible ?x - Localizacion)
        
        ; Representar que existe un camino entre dos localizaciones
        (conectado ?a - Localizacion ?b - Localizacion)
        
        ; Determinar si un personaje está trabajando en una localización extrayendo un recurso
        (trabajandoEn ?p - Personaje ?r - Recurso)
        
        ; igual que el predicado anterior pero sin indicar el personaje
        (alguienTrabajandoEn ?r - Recurso)
        
        ; Identificar si un personaje está disponible (no está trabajando)
        (disponible ?p - Personaje)
        
        ; Asignamos personas a tipos de Personaje
        (personajeEs ?p - Personaje ?tp - tipoPersonaje)
        
        ; 4 tipos de comunidades
        ;(comunidad ?h - Personaje ?m - Personaje)                                                      ; 1 hobbit + 1 mago
        ;(comunidad ?h1 - Personaje ?h2 - Personaje ?m1 - Personaje)                                    ; 2 hobbits + 1 mago
        ;(comunidad ?h1 - Personaje ?h2 - Personaje ?h3 - Personaje ?m1 - Personaje)                    ; 3 hobbits + 1 mago
        (comunidad ?h1 - Personaje ?h2 - Personaje ?h3 - Personaje ?m1 - Personaje ?e1 - Personaje)    ; 3 hobbits + 1 mago + 1 elfo
        
        ; Predicado para indicar que un personaje está en la comunidad creada
        (enComunidad ?p - Personaje)
        
        ; Predicado para indicar cuándo un personaje es portador de un Recurso
        (portadorDe ?p - Personaje ?rec - Recurso)
        
        ; Lugar de destrucción del Anillo
        (lugarDestruccion ?loc - Localizacion)
        
        ; Predicados sin parámetros que servirán a modo de variables bandera
        (anilloDestruido)
        (anilloRecogido)
        (mithrilRecogido)
        (espadaRecogida)
        (comunidadFormada)
    )
    
    ; acción para viajar individualmente
    (:action Viajar
        :parameters (?p - Personaje ?origen - Localizacion ?destino - Localizacion)
        :precondition
            (and
                ; el personaje disponible debe estar en la ciudad de origen y las ciudades, conectadas por el mapa
                (conectado ?origen ?destino)
                (en ?p ?origen)
                (disponible ?p)
                
                ; cambios: el personaje ?p podrá viajar individualmente si no está dentro de ninguna comunidad
                (not (enComunidad ?p))
            )
        :effect
            (and
                ; actualizamos la ubicación del personaje de forma individual
                (en ?p ?destino)
                (not (en ?p ?origen))
            )
    )
    
    (:action ExtraerRecurso
        :parameters (?p - Personaje ?loc - Localizacion ?rec - Recurso)
        :precondition
            (and
                ; solo trabajan los enanos en este ejercicio
                (personajeEs ?p Enano)
                
                ; el personaje debe estar disponible
                (disponible ?p)
                
                ; el personaje debe estar en un nodo del recurso ?rec
                (en ?rec ?loc)
                (en ?p ?loc)
            )
        :effect
            (and
                ; el personaje deja de estar disponible
                (not (disponible ?p))
                
                ; se actualizan los predicados correspondientes
                (trabajandoEn ?p ?rec)
                (alguienTrabajandoEn ?rec)
            )
    )

    ; 4 versiones de la acción según la comunidad que queremos formar
    (:action formarComunidad
        :parameters (?h1 - Personaje ?h2 - Personaje ?h3 - Personaje ?m1 - Personaje ?e1 - Personaje ?loc - Localizacion)
        :precondition
            (and
                ; personajes disponibles
                (disponible ?h1)
                (disponible ?h2)
                (disponible ?h3)
                (disponible ?m1)
                (disponible ?e1)
                
                ; solo se puede formar una comunidad
                (not (comunidadFormada))
                
                ; tipos de personajes que forman la comunidad según el tipo de comunidad
                ; debemos aclarar que los personajes del mismo tipo sean diferentes
                ; (si no, me los daba iguales como opción óptima)
                (not (= ?h1 ?h2))
                (not (= ?h1 ?h3))
                (not (= ?h3 ?h2))
                (personajeEs ?h1 Hobbit)
                (personajeEs ?h2 Hobbit)
                (personajeEs ?h3 Hobbit)
                (personajeEs ?m1 Mago)
                (personajeEs ?e1 Elfo)
                
                ; todos los personajes de la comunidad deben estar en la misma localización
                (en ?h1 ?loc)
                (en ?h2 ?loc)
                (en ?h3 ?loc)
                (en ?m1 ?loc)
                (en ?e1 ?loc)
            )
        :effect
            (and
                ; predicados que establecen la comunidad como formada
                (comunidad ?h1 ?h2 ?h3 ?m1 ?e1)
                (comunidadFormada)
                (enComunidad ?h1)
                (enComunidad ?h2)
                (enComunidad ?h3)
                (enComunidad ?m1)
                (enComunidad ?e1)
            )
    )
    
    ; 4 versiones de la acción según la comunidad que queremos formar
    (:action viajarComunidad
        :parameters (?origen - Localizacion ?destino - Localizacion ?h1 - Personaje ?h2 - Personaje ?h3 - Personaje ?m1 - Personaje ?e1 - Personaje)
        :precondition
            (and
                ; tipo de comunidad que consideramos
                (comunidad ?h1 ?h2 ?h3 ?m1 ?e1)
                
                ; todos los miembros de la comunidad están en la misma localización de origen
                (en ?h1 ?origen)
                (en ?h2 ?origen)
                (en ?h3 ?origen)
                (en ?m1 ?origen)
                (en ?e1 ?origen)
                
                ; las ciudades origen y destino están conectadas según el mapa
                (conectado ?origen ?destino)
            )
        :effect
            (and
                ; actualizamos la ubicación de todos los personajes que forman la comunidad por igual
                (en ?h1 ?destino)
                (en ?h2 ?destino)
                (en ?h3 ?destino)
                (en ?m1 ?destino)
                (en ?e1 ?destino)
                (not (en ?h1 ?origen))
                (not (en ?h2 ?origen))
                (not (en ?h3 ?origen))
                (not (en ?m1 ?origen))
                (not (en ?e1 ?origen))
            )
    )
    
    (:action recogerObjeto
        :parameters (?p - Personaje ?loc - Localizacion ?rec - Recurso)
        :precondition
            (and
                ; el personaje que coja un objeto debe ser un hobbit y estar dentro la comunidad creada
                (personajeEs ?p Hobbit)
                (enComunidad ?p)
                
                ; tanto el hobbit como el recurso a coger deben estar en el mismo sitio
                (en ?p ?loc)
                (en ?rec ?loc)
                
                ; todos los objetos se recogen una vez
                (imply (= ?rec Anillo)  (not (anilloRecogido)))
                (imply (= ?rec Espada)  (not (espadaRecogida)))
                (imply (= ?rec Mithril) (not (mithrilRecogido)))
                
                ; el anillo es el primer recurso que coge la comunidad; por tanto, si se coge 
                ; cualquiera de los otros recursos, ya debe de haber un portador del Anillo
                ; que coincide con el personaje actual
                (imply (not (= ?rec Anillo)) (portadorDe ?p Anillo))
            )
        :effect
            (and
                ; establecemos el portador del objeto encontrado
                (portadorDe ?p ?rec)
                
                ; añadimos recursoRecogido según el caso
                (when (= ?rec Anillo) (anilloRecogido))
                (when (= ?rec Espada) (espadaRecogida))
                (when (= ?rec Mithril) (mithrilRecogido))
            )
    )
    
     (:action destruirAnillo
        :parameters (?p - Personaje ?loc - Localizacion)
        :precondition
            (and
                ; el personaje que destruya el anillo debe ser un hobbit y estar dentro de la comunidad creada
                (personajeEs ?p Hobbit)
                (enComunidad ?p)
                
                ; el hobbit debe estar en la posición donde se debe destruir el anillo, indicada por el predicado
                ; lugarDestriccion que se inicializa en el archivo del problema
                (en ?p ?loc)
                (lugarDestruccion ?loc)
                
                ; el hobbit debe ser portador de los 3 objetos necesarios
                (portadorDe ?p Anillo)
                (portadorDe ?p Espada)
                (portadorDe ?p Mithril)
                
                ; solo se destruye una vez el anillo
                (not (anilloDestruido))
            )
        :effect
            (and
                ; el anillo queda destruido
                (anilloDestruido)
                (not (portadorDe ?p Anillo))
            )
    )
)
