;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 2 - Práctica 3 TSI
; Elena Torres Fernández
; dominio2.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain ejercicio2)
    (:requirements :strips :typing :adl) ; adl para incluir or en las precondiciones
    (:types
        movible Localizacion - object
        Personaje Recurso - movible
    )
    (:constants
        Enano Hobbit Mago - Personaje
        Mineral Mithril Madera Especia Alimento Anillo Espada - Recurso
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
        (personajeEs ?p - Personaje ?e - Enano)
        
        ; dos personajes constituyen una comunidad
        ; indicamos dos personajes pero en la acción formarComunidad se exige que
        ; el primero sea Hobbit y el segundo, Mago
        (comunidad ?h - Personaje ?m - Personaje)
        
        ; Predicado para indicar que un personaje está en la comunidad creada
        (enComunidad ?p - Personaje)
        
        ; predicado para indicar cuándo un personaje es portador de un Recurso
        (portadorDe ?p - Personaje ?rec - Recurso)
        
        ; lugar de destrucción del Anillo
        (lugarDestruccion ?loc - Localizacion)
        
        ; predicados sin parámetros que servirán a modo de variables bandera
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
                ; el personaje debe estar en la ciudad de origen y las ciudades, conectadas por el mapa
                (conectado ?origen ?destino)
                (en ?p ?origen)
                
                ; personaje disponible
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
    
    (:action formarComunidad
        :parameters (?p1 - Personaje ?p2 - Personaje ?loc - Localizacion)
        :precondition
            (and
                ; personajes disponibles
                (disponible ?p1)
                (disponible ?p2)
                
                ; solo se puede formar una comunidad, lo conseguimos creando el predicado
                ; comunidadFormada en los consecuentes y negándola como precondición
                (not (comunidadFormada))
                
                ; la comunidad se forma con un hobbit y un mago
                (personajeEs ?p1 Hobbit)
                (personajeEs ?p2 Mago)
                
                ; ambos personajes deben estar en la misma localización
                (en ?p1 ?loc)
                (en ?p2 ?loc)
            )
        :effect
            (and
                ; predicados para indicar que la comunidad se ha creado
                (comunidad ?p1 ?p2)
                (comunidadFormada)
                (enComunidad ?p1)
                (enComunidad ?p2)
            )
    )
    
    (:action viajarComunidad
        :parameters (?origen - Localizacion ?destino - Localizacion ?p1 - Personaje ?p2 - Personaje)
        :precondition
            (and
                ; la comunidad debe estar formada
                (comunidad ?p1 ?p2)
                
                ; ambos están en la misma localización de origen
                (en ?p1 ?origen)
                (en ?p2 ?origen)
                
                ; las ciudades origen y destino están conectadas según el mapa
                (conectado ?origen ?destino)
            )
        :effect
            (and
                ; actualizamos la localización de ambos personajes que forman la comunidad por igual
                (en ?p1 ?destino)
                (en ?p2 ?destino)
                (not (en ?p1 ?origen))
                (not (en ?p2 ?origen))
            )
    )
    
    (:action recogerObjeto
        :parameters (?p - Personaje ?loc - Localizacion ?rec - Recurso)
        :precondition
            (and
                ; el personaje que coja un objeto debe ser un hobbit y estar dentro de la comunidad
                (personajeEs ?p Hobbit)
                (enComunidad ?p)
                
                ; tanto el hobbit como el recurso a coger deben estar en el mismo sitio
                (en ?p ?loc)
                (en ?rec ?loc)
                
                ; todos los objetos se recogen una vez: si ya se ha cogido una vez no puede volver a cogerse
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
                
                ; el hobbit debe estar en la posición donde se debe destruir el anillo,
                ; indicada por el predicado lugarDestriccion que se inicializa en el archivo del problema
                (en ?p ?loc)
                (lugarDestruccion ?loc)
                
                ; el hobbit debe ser portador de los 3 objetos necesarios
                (portadorDe ?p Anillo)
                (portadorDe ?p Espada)
                (portadorDe ?p Mithril)
                
                ; el anillo solo se destruye una vez
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