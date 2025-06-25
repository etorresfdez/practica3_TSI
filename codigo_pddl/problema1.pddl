;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ejercicio 1 - Práctica 3 TSI
; Elena Torres Fernández
; problema1.pddl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem ejercicio1)
    (:domain ejercicio1)
    (:objects
        Hobbiton Bree Rivendell HighPass Mirkwood Erebor Moria Lothlorien Tharbad Fangorn Isengard HelmsDeep Edoras AmonHen MinasTirith DolAmroth Tolfolas MinasMorgul DeadMarshes Orodruin - Localizacion
        Enano1 Enano2 Hobbit1 - Personaje
    )
    (:init
        ; indicamos los tipos de personaje usando las constantes tipo de personaje
        (personajeEs Enano1 Enano)
        (personajeEs Enano2 Enano)
        (personajeEs Hobbit1 Hobbit)
        
        ; indicamos las localizaciones de los recursos
        (en Mineral Moria)
        (en Mineral Erebor)
        (en Mithril Moria)
        (en Madera Fangorn)
        (en Madera Lothlorien)
        (en Madera Mirkwood)
        (en Especia Tolfolas)
        (en Alimento Hobbiton)
        
        ; localizaciones de los personajes
        (en Enano1 Tharbad)
        (en Enano2 Isengard)
        (en Hobbit1 Isengard)
        (disponible Enano1)
        (disponible Hobbit1)        
        ; no hace falta añadir nada para indicar que el Enano2 no está disponible
        ; se tiene por la hipótesis del mundo cerrado
        
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
            ; que haya algún personaje trabajando en madera
            (alguienTrabajandoEn Madera)
        )
    )
)
