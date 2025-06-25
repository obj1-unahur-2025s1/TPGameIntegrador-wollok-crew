import wollok.game.*
import paquetes.*

class Cliente inherits EntidadVisual{
    const idPaqueteElegido = [0, 1, 2, 3].anyOne()
    const imagen = ["Cliente01.png", "Cliente02.png", "Cliente03.png", "Cliente04.png"].anyOne()
    override method image() = imagen
    method idPaqueteElegido() = idPaqueteElegido
}



class BurbujaCliente {
    const cliente
    method cliente() = cliente
    const position = cliente.position().up(2).right(1)
    const imagen = ["burbujaBebida.png","burComida.png","burbujaMedicina.png","burbujaRopa.png"].get(cliente.idPaqueteElegido())

    method image() = imagen
    method position() = position

}


object randomizadorClientesPos {
    const todasLasPosiciones = [
        [2, 2], [4, 2], [6, 2], [15, 2], [17, 2], [19, 2], [21, 2],
        [15, 7], [17, 7], [19, 7], [21, 7], [2, 7], [4, 7], [6, 7],
        [2, 18], [4, 18], [6, 18], [15, 18], [17, 18], [19, 18], [21, 18]
    ]
    var posicionesDisponibles = todasLasPosiciones.copy()

    method posicionAleatoriaCliente() {
        if (posicionesDisponibles.isEmpty()) {
            posicionesDisponibles = todasLasPosiciones.copy()
        }
        const pos = posicionesDisponibles.anyOne()
        posicionesDisponibles.remove(pos)
        return pos
    }

    method liberarPosicion(pos) {
        const posLista = [pos.x(), pos.y()]
        if (!posicionesDisponibles.contains(posLista)) {
            posicionesDisponibles.add(posLista)
        }
    }
}


object listaClientes{
    const totalClientes = []
    const burbujas = []

    method totalClientes() = totalClientes

    method posiciones() = totalClientes.map({o=>o.position()})

    method crearCliente() {
        if (totalClientes.size() < 4){
            const pos = randomizadorClientesPos.posicionAleatoriaCliente()
            const cliente = new Cliente(position = game.at(pos.get(0),pos.get(1)))
            const burbuja = new BurbujaCliente(cliente = cliente)
            totalClientes.add(cliente)
            burbujas.add(burbuja)
            listaPaquetes.crearPaquete(cliente.idPaqueteElegido())
            game.addVisual(cliente)
            game.addVisual(burbuja)
        }
    }

    method sacarCliente(cliente) {
        totalClientes.remove(cliente)
        game.removeVisual(cliente)
        const bur = burbujas.find({b=>b.cliente() == cliente})
        game.removeVisual(bur)
        burbujas.remove(bur)
    }

    method vaciarClientes() {
        totalClientes.forEach({c=>self.sacarCliente(c)})
    }
}