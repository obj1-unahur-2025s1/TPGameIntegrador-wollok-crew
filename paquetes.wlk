import menu.*
import clientes.*
import wollok.game.*

class EntidadVisual{
    var property position
    method image()
    method hitbox() = [self.position()]
}

class Paquete inherits EntidadVisual{
    var tipoPaquete = [paqueteDeComida, paqueteBebida, paqueteFarmacia, paqueteRopa].anyOne()
    var imagenDePaquete = tipoPaquete.image()
    var burbujaDePaquete = tipoPaquete.burbuja()

    override method image() = imagenDePaquete
    method burbuja() = burbujaDePaquete
    
    method actualizarContenido() {
        tipoPaquete = [paqueteDeComida, paqueteBebida, paqueteFarmacia, paqueteRopa].anyOne()
        position = randomizadorPaquete.posicionAleatoriaPaquete()
        imagenDePaquete = tipoPaquete.image()
        burbujaDePaquete = tipoPaquete.burbuja()
    }

    method tipoPaquete() = tipoPaquete 
}

object paqueteDeComida {
    method image() = "Paq_Comida50.png"
    method burbuja() = "burComida2.png"
}

object paqueteBebida {
    method image() = "Paq_Bebidas50.png"
    method burbuja() = "burbujaBebida2.png"
}

object paqueteFarmacia {
    method image() = "Paq_Farmacia50.png"
    method burbuja() = "burbujaMedicina2.png"
}

object paqueteRopa {
    method image() = "Paq_Zapatos50.png"
    method burbuja() = "burbujaRopa2.png"
}

object randomizadorPaquete {
    const todasLasPosiciones = [
        game.at(2,0), game.at(4,0), game.at(6,0), game.at(6,2), game.at(6,4), game.at(6,6), game.at(6,8), game.at(8,0),
        game.at(0,5), game.at(2,5), game.at(4,5), game.at(9,5)
    ]
    var posicionesDisponibles = todasLasPosiciones.copy()

    method posicionAleatoriaPaquete() {
        if (posicionesDisponibles.isEmpty()) {
            posicionesDisponibles = todasLasPosiciones.copy()
        }
        const pos = posicionesDisponibles.anyOne()
        posicionesDisponibles.remove(pos)
        return pos
    }

    method liberarPosicion(pos) {
        if (!posicionesDisponibles.contains(pos)) {
            posicionesDisponibles.add(pos)
        }
    }
}

object listaPaquetes{
    const paq1 = new Paquete(position = randomizadorPaquete.posicionAleatoriaPaquete())
    const paq2 = new Paquete(position = randomizadorPaquete.posicionAleatoriaPaquete())
    const paq3 = new Paquete(position = randomizadorPaquete.posicionAleatoriaPaquete())
    const paq4 = new Paquete(position = randomizadorPaquete.posicionAleatoriaPaquete())

    const paquetesActivos = []
    var paquetesDisponibles1 = [paq1, paq2, paq3, paq4]

    method paquetesActivos() = paquetesActivos
    method paquetesDisponibles() {
        if (paquetesDisponibles1.isEmpty()) {
            paquetesDisponibles1 = [paq1, paq2, paq3, paq4]
        }
        return paquetesDisponibles1
    } 

    method posiciones() = paquetesDisponibles1.map({o=>o.position()})

    method crearPaquete(paquete) {
        if (!paquetesActivos.contains(paquete)) {
            paquetesActivos.add(paquete)
            game.addVisual(paquete)
            paquetesDisponibles1.remove(paquete)
        }
    }

    method sacarPaquete(paquete) {
        paquetesActivos.remove(paquete)
        game.removeVisual(paquete)
    }

    method reiniciar() {
        paquetesActivos.clear()
        paquetesDisponibles1 = [paq1, paq2, paq3, paq4]
        paquetesDisponibles1.forEach({p =>
            game.removeVisual(p)  
        })
    }

    method devolverPaquete(paquete) {
        paquete.actualizarContenido()
        paquetesDisponibles1.add(paquete)
        self.crearPaquete(paquete)
    }

    method estaVacioDisponibles() = paquetesDisponibles1.isEmpty()
}