;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 5 - Práctica 3 TSI
; Elena Torres Fernández
; dominio5.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain ejercicio5)
    ; :action-costs para pddl numérico y :adl para or en precondiciones
    (:requirements :strips :typing :adl :action-costs) 
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
        ; llamamos conectao a las que se unen con coste unitario y conectado3, con coste 3
        (conectado ?a - Localizacion ?b - Localizacion)
        (conectado3 ?a - Localizacion ?b - Localizacion) ; diferencia ejer5
        
        ; Determinar si un personaje está trabajando en una localización extrayendo un recurso
        (trabajandoEn ?p - Personaje ?r - Recurso)
        
        ; igual que el predicado anterior pero sin especificar el personaje
        (alguienTrabajandoEn ?r - Recurso)
        
        ; Identificar si un personaje está disponible (no está trabajando)
        (disponible ?p - Personaje)
        
        ; asignamos personas a tipos de Personaje
        (personajeEs ?p - Personaje ?e - tipoPersonaje)
    )
    
    (:functions
        (total-cost)        ; coste del plan
        (camino-especial)   ; coste del camino especial (3 en este caso)
    )
        
    (:action ViajarUnitario
        :parameters (?p - Personaje ?origen - Localizacion ?destino - Localizacion)
        :precondition
            (and
                ; existe una conexión unitaria entre las ciudades
                (conectado ?origen ?destino)
                
                ; el personaje está en la localización de origen
                (en ?p ?origen)
            )
        :effect
            (and
                ; actualizamos localización del personaje
                (en ?p ?destino)
                (not (en ?p ?origen))
                
                ; incrementamos la variable/función coste-camino según el tipo de conexión
                (increase (total-cost) 1)
            )
    )
    
    (:action ViajarEspecial
        :parameters (?p - Personaje ?origen - Localizacion ?destino - Localizacion)
        :precondition
            (and
                ; existe una conexión unitaria entre las ciudades
                (conectado3 ?origen ?destino)
                
                ; el personaje está en la localización de origen
                (en ?p ?origen)
            )
        :effect
            (and
                ; actualizamos localización del personaje
                (en ?p ?destino)
                (not (en ?p ?origen))
                
                ; incrementamos la variable/función coste-camino según el tipo de conexión
                (increase (total-cost) (camino-especial))
            )
    )
    
    (:action ExtraerRecurso
        :parameters (?p - Personaje ?loc - Localizacion ?rec - Recurso)
        :precondition
            (and
                ; el personaje debe estar disponible y ser un Enano
                (personajeEs ?p Enano)
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
                
                ; también incrementa el coste del plan! (en uno)
                (increase (total-cost) 1)
            )
    )
)
