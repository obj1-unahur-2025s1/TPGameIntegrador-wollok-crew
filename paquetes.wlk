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
        randomizadorPaquete.generarPosicionDisponible()
        position = randomizadorPaquete.posicionDisponible()
        id = [0,1,2,3].anyOne()
        imagen = ["Paq_Bebidas.png","Paq_Comida.png","Paq_Farmacia.png","Paq_Zapatos.png"].get(id)
        burbuja = ["burbujaBebida.png","burComida.png","burbujaMedicina.png","burbujaRopa.png"].get(id)
        }
}


object randomizadorPaquete {
    const posiciones = []
    var posicionesDisponibles = posiciones.copy()
    var posicionDisponible = null

    method posicionDisponible() = posicionDisponible

    method liberarPosicion(pos) {
        if (!posicionesDisponibles.contains(pos)) {
            posicionesDisponibles.add(pos)
        }
    }

    method generarPosicionDisponible() {
        if (posiciones.isEmpty()){
            self.generarPosiciones()
         }
        if (posicionesDisponibles.isEmpty()) {
            posicionesDisponibles = posiciones.copy()
        }
        posicionDisponible = posicionesDisponibles.anyOne()
        posicionesDisponibles.remove(posicionDisponible)
    } 

    method generarPosiciones() {
        // Bloque 1: fila (y = 4) y (y = 16), x = 0 a 6
        (1..6).forEach({ x => posiciones.add(game.at(x, 4)) posiciones.add(game.at(x,16)) })

         // Bloque 2 y 3: fila (y = 4) y (y = 16), x = 15 a 20 y 22 a 23
        (16..20).forEach({ x => posiciones.add(game.at(x, 4)) posiciones.add(game.at(x, 16)) })
        [22,23].forEach({ x => posiciones.add(game.at(x, 4)) posiciones.add(game.at(x, 16)) })

        // Bloque 4 y 5: columna x = 12, y = 23 a 19 y también 0, 1, 2
        (19..23).forEach({ y => posiciones.add(game.at(12, y)) })
        (0..2).forEach({ y => posiciones.add(game.at(12, y)) })
    } 
}

object listaPaquetes{
    const paq1 = new Paquete(position = game.at(15,16))
    const paq2 = new Paquete(position = game.at(0,4))
    const paq3 = new Paquete(position = game.at(0,16))
    const paq4 = new Paquete(position = game.at(15,4))


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