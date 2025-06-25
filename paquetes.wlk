import menu.*
import clientes.*
import wollok.game.*
class EntidadVisual{
    var property position
    method image()
    method hitbox() = [self.position(), self.position().up(1), self.position().right(1), self.position().right(1).up(1)]
}
class Paquete inherits EntidadVisual{
    var property idPaquete
    const imagen = ["Paq_Bebidas.png","Paq_Comida.png","Paq_Farmacia.png","Paq_Zapatos.png"].get(idPaquete)
    override method image() = imagen
}


object randomizadorPaquete {
    const todasLasPosiciones = [
        [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
        [15, 4], [16, 4], [17, 4], [18, 4], [19, 4], [20, 4], [22, 4], [23, 4],
        [15, 16], [16, 16], [17, 16], [18, 16], [19, 16], [20, 16], [21, 16], [22, 16], [23, 16],
        [0, 16], [1, 16], [2, 16], [3, 16], [4, 16], [5, 16], [6, 16],
        [12, 23], [12, 22], [12, 21], [12, 20], [12, 19], [12, 0], [12, 1], [12, 2]
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
    const totalPaquetes = []
    method totalPaquetes() = totalPaquetes

    method posiciones() = totalPaquetes.map({o=>o.position()})

    method crearPaquete(id) {
        const pos = randomizadorPaquete.posicionAleatoriaPaquete()
        const paq = new Paquete(position = game.at(pos.get(0),pos.get(1)), idPaquete = id)
        totalPaquetes.add(paq)
        game.addVisual(paq)
    }

    method sacarPaquete(paquete) {
        totalPaquetes.remove(paquete)
        game.removeVisual(paquete)
    }
}