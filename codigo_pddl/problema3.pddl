;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 3 - Práctica 3 TSI
; Elena Torres Fernández
; problema3.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem ejercicio3)
    (:domain ejercicio3)
    (:objects
        Hobbiton Bree Rivendell HighPass Mirkwood Erebor Moria Lothlorien Tharbad Fangorn Isengard HelmsDeep Edoras AmonHen MinasTirith DolAmroth Tolfolas MinasMorgul DeadMarshes Orodruin - Localizacion
        Enano1 Enano2 Elfo1 Humano1 Humano2 Hobbit1 Hobbit2 Hobbit3 Hobbit4 Mago1 Mago2 - Personaje
    )
    (:init
        ; indicamos los tipos de personaje usando las constantes tipo de personaje
        (personajeEs Enano1 Enano)
        (personajeEs Enano2 Enano)
        (personajeEs Elfo1 Elfo)
        (personajeEs Humano1 Humano)
        (personajeEs Humano2 Humano)
        (personajeEs Hobbit1 Hobbit)
        (personajeEs Hobbit2 Hobbit)
        (personajeEs Hobbit3 Hobbit)
        (personajeEs Hobbit4 Hobbit)
        (personajeEs Mago1 Mago)
        (personajeEs Mago2 Mago)
        
        ; indicamos las localizaciones de los recursos usando las constantes tipos de recurso
        (en Mineral Moria)
        (en Mineral Erebor)
        (en Mithril Moria)
        (en Madera Fangorn)
        (en Madera Lothlorien)
        (en Madera Mirkwood)
        (en Especia Tolfolas)
        (en Alimento Hobbiton)
        (en Anillo Rivendell)
        (en Espada Lothlorien)
        
        ; localizaciones de los personajes
        (en Enano1 Fangorn)
        (en Enano2 Moria)
        (en Elfo1 Lothlorien)
        (en Humano1 Edoras)
        (en Humano2 Edoras)
        (en Hobbit1 Hobbiton)
        (en Hobbit2 Hobbiton)
        (en Hobbit3 Hobbiton)
        (en Hobbit4 Bree)
        (en Mago1 Rivendell)
        (en Mago2 Isengard)
        
        ; todos los personajes disponibles
        (disponible Hobbit1)
        (disponible Hobbit2)
        (disponible Hobbit3)
        (disponible Hobbit4)
        (disponible Mago1)
        (disponible Mago2)
        (disponible Elfo1)
        (disponible Enano1)
        (disponible Enano2)
        (disponible Humano1)
        (disponible Humano2)
        
        ; lugar de destrucción del Anillo
        (lugarDestruccion Orodruin)
        
        ; mapa de las localizaciones
        ; aristas duplicadas intercambiando ciudades
        (conectado Hobbiton Bree)
        (conectado Bree Hobbiton)
        (conectado Bree Rivendell)
        (conectado Rivendell Bree)
        (conectado Rivendell HighPass)
        (conectado HighPass Rivendell)
        (conectado HighPass Mirkwood)
        (conectado Mirkwood HighPass)
        (conectado Mirkwood Erebor)
        (conectado Erebor Mirkwood)
        (conectado Hobbiton Tharbad)
        (conectado Tharbad Hobbiton)
        (conectado Bree Tharbad)
        (conectado Tharbad Bree)
        (conectado Tharbad HelmsDeep)
        (conectado HelmsDeep Tharbad)
        (conectado HelmsDeep Isengard)
        (conectado Isengard HelmsDeep)
        (conectado Isengard Fangorn)
        (conectado Fangorn Isengard)
        (conectado Fangorn AmonHen)
        (conectado AmonHen Fangorn)
        (conectado AmonHen Lothlorien)
        (conectado Lothlorien AmonHen)
        (conectado Lothlorien Moria)
        (conectado Moria Lothlorien)
        (conectado Moria Rivendell)
        (conectado Rivendell Moria)
        (conectado HelmsDeep Edoras)
        (conectado Edoras HelmsDeep)
        (conectado Edoras DolAmroth)
        (conectado DolAmroth Edoras)
        (conectado DolAmroth Tolfolas)
        (conectado Tolfolas DolAmroth)
        (conectado Tolfolas MinasTirith)
        (conectado MinasTirith Tolfolas)
        (conectado MinasTirith Edoras)
        (conectado Edoras MinasTirith)
        (conectado MinasTirith MinasMorgul)
        (conectado MinasMorgul MinasTirith)
        (conectado MinasMorgul Orodruin)
        (conectado MinasMorgul DeadMarshes)
        (conectado Orodruin MinasMorgul)
        (conectado DeadMarshes MinasMorgul)
        (conectado DeadMarshes AmonHen)
        (conectado AmonHen DeadMarshes)
    )
    (:goal
        (and
            (anilloDestruido)
        )
    )
)