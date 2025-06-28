import menu.*
import clientes.*
import wollok.game.*
class EntidadVisual{
    var property position
    method image()
    method hitbox() = [self.position(), self.position().up(1), self.position().right(1), self.position().right(1).up(1)]
    method burbuja()
}
class Paquete inherits EntidadVisual{
    var id = [0,1,2,3].anyOne()

    var imagen = ["Paq_Bebidas.png","Paq_Comida.png","Paq_Farmacia.png","Paq_Zapatos.png"].get(id)
    var burbuja = ["burbujaBebida.png","burComida.png","burbujaMedicina.png","burbujaRopa.png"].get(id)
    override method image() = imagen
    override method burbuja() = burbuja
    
    method actualizarContenido() {
        position = randomizadorPaquete.posicionAleatoriaPaquete()
        id = [0,1,2,3].anyOne()
        imagen = ["Paq_Bebidas.png","Paq_Comida.png","Paq_Farmacia.png","Paq_Zapatos.png"].get(id)
        burbuja = ["burbujaBebida.png","burComida.png","burbujaMedicina.png","burbujaRopa.png"].get(id)
        }
}


object randomizadorPaquete {
    const todasLasPosiciones = [
        game.at(0,4), game.at(1,4), game.at(2,4), game.at(3,4), game.at(4,4), game.at(5,4), game.at(6,4),
        game.at(0,16), game.at(1,16), game.at(2,16), game.at(3,16), game.at(4,16), game.at(5,16), game.at(6,16),
        game.at(15,4), game.at(16,4), game.at(17,4), game.at(18,4), game.at(19,4), game.at(20,4), game.at(22,4), game.at(23,4),
        game.at(15,16), game.at(16,16), game.at(17,16), game.at(18,16), game.at(19,16), game.at(20,16), game.at(21,16), game.at(22,16), game.at(23,16),
        game.at(12,23), game.at(12,22), game.at(12,21), game.at(12,20), game.at(12,19) ,game.at(12,0) ,game.at(12,1), game.at(12,2)
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
    const paquetesDisponibles = [paq1,paq2,paq3,paq4]

    method paquetesActivos() = paquetesActivos
    method paquetesDisponibles() = paquetesDisponibles

    method posiciones() = paquetesDisponibles.map({o=>o.position()})

    method crearPaquete(paquete) {
        paquetesDisponibles.remove(paquete)
        paquetesActivos.add(paquete)
        game.addVisual(paquete)
    }

    method sacarPaquete(paquete) {
        paquetesDisponibles.add(paquete)
        paquetesActivos.remove(paquete)
        game.removeVisual(paquete)
    }
}