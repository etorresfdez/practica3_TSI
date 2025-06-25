;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 4 - Práctica 3 TSI
; Elena Torres Fernández
; dominio4.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain ejercicio4)
    (:requirements :strips :typing :adl) ; :adl para incluir or en las precondiciones
    (:types
        tipoPersonaje tipoEdificio Edificio movible Localizacion - object
        Personaje Recurso - movible
    )
    (:constants
        Enano Hobbit Mago Elfo Humano - tipoPersonaje
        Mineral Mithril Madera Especia Alimento Anillo Espada - Recurso
        Fortaleza Extractor - tipoEdificio
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
        
        ;;; nuevos predicados
        ; predicados para comprobar si un recurso es Madera, Mithril o Mineral
        (esMadera ?rec - Recurso)
        (esMithril ?rec - Recurso)
        (esMineral ?rec - Recurso)
        
        ; Indica los recursos que necesita cada tipo de edificio
        (necesita ?te - tipoEdificio ?rec - Recurso)
        
        ; Indica de qué tipo es un edificio concreto
        (edificioEs ?e - Edificio ?te - tipoEdificio)
        
        ; qué edificios hay construidos y dónde
        (edificioConstruido ?edif - Edificio ?loc - Localizacion)
        
        ; predicados sin parámetros actuando como variables bandera
        (extractorConstruido)
        (todosHobbitsProduciendo)
    )
    
    ; acción para viajar individualmente
    (:action Viajar
        :parameters (?p - Personaje ?origen - Localizacion ?destino - Localizacion)
        :precondition
            (and
                ; personaje que viaja disponible
                (disponible ?p)
                
                ; personaje en la ciudad de origen
                (en ?p ?origen)
                
                ; ciudades de origen y destino conectadas
                (conectado ?origen ?destino)
            )
        :effect
            (and
                ; actualizamos la ubicación del personaje
                (en ?p ?destino)
                (not (en ?p ?origen))
            )
    )
    
    ; ahora no trabajan solo los Enanos, también los Humanos y Hobbits,
    ; cada uno para construir un recurso en específico
    (:action ExtraerRecurso
        :parameters (?p - Personaje ?loc - Localizacion ?rec - Recurso)
        :precondition
            (and 
                ; el personaje debe estar disponible
                (disponible ?p)
                
                ; la localizacion proporcionada debe ser un nodo de ese recurso
                (en ?rec ?loc)
                
                ; el personaje debe estar en la misma localizacion
                (en ?p ?loc)
                
                ; si el personaje no es un hobbit,
                ; deben estar todos los hobbits produciendo Alimento
                (imply (not (personajeEs ?p Hobbit)) (todosHobbitsProduciendo))
                
                ; los enanos fabrican madera o mithril
                (imply (personajeEs ?p Enano) (or (= ?rec Mithril)(= ?rec Madera)))
                
                ; los humanos fabrican mineral
                (imply (personajeEs ?p Humano) (= ?rec Mineral))
                
                ; los hobbits fabrican Alimento
                (imply (personajeEs ?p Hobbit) (= ?rec Alimento))
            )
        :effect
            (and
                (trabajandoEn ?p ?rec)
                
                ; activamos el predicado de recurso en producción según el recurso
                (when (esMadera ?rec)
                    (alguienTrabajandoEn Madera)
                )
                (when (esMithril ?rec)
                    (alguienTrabajandoEn Mithril)
                )
                (when (esMineral ?rec)
                    (alguienTrabajandoEn Mineral)
                )
                
                ; cuando todos los hobbits estén produciendo alimento,
                ; activamos el predicado (todosHobbitsProduciendo)
                (when 
                    (forall (?h - Personaje)
                        (imply (personajeEs ?h Hobbit)
                            (trabajandoEn ?h Alimento)
                        )
                    )
                    (todosHobbitsProduciendo)
                )
                
                ; el personaje deja de estar disponible
                (not (disponible ?p))
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
    
    ; acción para construir una fortaleza por un Mago y un extractor por un Humano,
    ; siempre que haya alguien fabricando los recursos necesarios en cada caso
    (:action Construir
        :parameters (?per - Personaje ?edif - Edificio ?loc - Localizacion)
        :precondition
            (and
                ; la persona constructora tiene q estar disponible
                (disponible ?per)
                
                ; 2 casos según el tipo de edificio:
                (or
                    ; caso Extractor
                    (and
                        (edificioEs ?edif Extractor)
                        (personajeEs ?per Humano)       ; personaje que construye extractores
                        (= ?loc Moria)                  ; única localización posible de los extractores
                        
                        ; para todos los recursos que necesiten los extractores,
                        ; hay un personaje trabajando en él
                        (forall (?rec - Recurso)
                            (imply (necesita Extractor ?rec)
                                (alguienTrabajandoEn ?rec)
                            )
                        )
                    )
                    
                    ;; caso Fortaleza
                    (and
                        (edificioEs ?edif Fortaleza)
                        (personajeEs ?per Mago)         ; personaje que construye fortalezas
                        (extractorConstruido)           ; debe haber un extractor construido
                        
                        ; para todos los recursos que necesiten las fortalezas,
                        ; hay un personaje trabajando en él
                        (forall (?rec - Recurso)
                            (imply (necesita Fortaleza ?rec)
                                (alguienTrabajandoEn ?rec)
                            )
                        )
                    )
                )
            )
        :effect
            (and
                (edificioConstruido ?edif ?loc)
                
                ; activamos la bandera de Extractor construido
                (when (edificioEs ?edif Extractor) (extractorConstruido))
                
                ; el personaje constructor sigue estando disponible
                ; NO hay que poner (not (disponible ?per)) como efecto
            )
    )
)