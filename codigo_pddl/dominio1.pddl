;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 1 - Práctica 3 TSI
; Elena Torres Fernández
; dominio1.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain ejercicio1)
    (:requirements :strips :typing)
    (:types
        tipoPersonaje movible Localizacion - object
        Personaje Recurso - movible
    )
    (:constants
        Enano Hobbit - tipoPersonaje
        Mineral Mithril Madera Especia Alimento - Recurso
    )
    (:predicates
        ; Determinar si un personaje o nodo de recurso está en una localización determinada
        (en ?obj - movible ?x - Localizacion)
        
        ; Representar que existe un camino entre dos localizaciones
        ; ponemos duplicadas las conexiones intercambiando a y b para que se pueda viajar
        ; en ambos sentidos segun la accion Viajar
        (conectado ?a - Localizacion ?b - Localizacion)
        
        ; Determinar si un personaje está trabajando en una localización extrayendo un recurso
        (trabajandoEn ?p - Personaje ?r - Recurso)
        
        ; igual que el predicado anterior pero sin indicar el personaje
        (alguienTrabajandoEn ?r - Recurso)
        
        ; Identificar si un personaje está disponible (no está trabajando)
        (disponible ?p - Personaje)
        
        ; asignamos personas a tipos de Personaje
        (personajeEs ?p - Personaje ?tp - tipoPersonaje)
        
    )
    
    (:action Viajar
        :parameters (?p - Personaje ?origen - Localizacion ?destino - Localizacion)
        :precondition
            (and
                ; debe haber camino entre la ciudad origen y destino
                (conectado ?origen ?destino)
                
                ; el personaje está en la localización de origen
                (en ?p ?origen)
            )
        :effect
            (and
                ; actualización de la ubicación del personaje
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
)
