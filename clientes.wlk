import wollok.game.*
import paquetes.*

class Cliente inherits EntidadVisual{
    var paqueteElegido = listaPaquetes.paquetesDisponibles().anyOne()
    var imagen = ["Cliente01.png", "Cliente02.png", "Cliente03.png", "Cliente04.png"].anyOne()
    var burbuja = paqueteElegido.burbuja()
    override method image() = imagen
    method paqueteElegido() = paqueteElegido
    method elegirPaquete(paquete) {paqueteElegido = paquete}

    method actualizarPosicion() {
        position = randomizadorClientesPos.posicionAleatoriaCliente()
        imagen = ["Cliente01.png", "Cliente02.png", "Cliente03.png", "Cliente04.png"].anyOne()
        self.elegirPaquete(listaPaquetes.paquetesDisponibles().anyOne())
        burbuja = paqueteElegido.burbuja()
        }

    method recibirPaquete(paquete) {
        paquete.actualizarContenido()
        listaClientes.sacarCliente(self)
    }
    
    override method burbuja() = burbuja
}

class BurbujaCliente {
    const cliente
    method cliente() = cliente
    var position = cliente.position().up(2).right(1)
    var imagen = cliente.burbuja()
    
    method image() = imagen
    method position() = position
    method actualizarPosicion() {
        position = cliente.position().up(2).right(1)
        imagen = cliente.burbuja()}

}


object randomizadorClientesPos {
    const todasLasPosiciones = [
        game.at(2,2), game.at(4,2), game.at(6,2), game.at(15,2), game.at(17,2), game.at(19,2), game.at(21,2),
        game.at(15,7), game.at(17,7), game.at(19,7), game.at(21,7), game.at(2,7), game.at(4,7), game.at(6,7),
        game.at(2,18), game.at(4,18), game.at(6,18), game.at(15,18), game.at(17,18), game.at(19,18), game.at(21,18)
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
        if (!posicionesDisponibles.contains(pos)) {
            posicionesDisponibles.add(pos)
        }
    }
}


object listaClientes{
    const cli1 = new Cliente(position = randomizadorClientesPos.posicionAleatoriaCliente())
    const cli2 = new Cliente(position = randomizadorClientesPos.posicionAleatoriaCliente())
    const cli3 = new Cliente(position = randomizadorClientesPos.posicionAleatoriaCliente())
    const cli4 = new Cliente(position = randomizadorClientesPos.posicionAleatoriaCliente())

    const bur1 = new BurbujaCliente(cliente = cli1)
    const bur2 = new BurbujaCliente(cliente = cli2)
    const bur3 = new BurbujaCliente(cliente = cli3)
    const bur4 = new BurbujaCliente(cliente = cli4)

    const clientesDisponibles = [cli1,cli2,cli3,cli4]
    const clientesActuales = []

    const burbujasDisponibles = [bur1,bur2,bur3,bur4]

    method clientesActuales() = clientesActuales

    method posiciones() = clientesActuales.map({o=>o.position()})

    method crearCliente() {
        if (clientesActuales.size() < 4){
            const cliente = clientesDisponibles.anyOne()
            clientesActuales.add(cliente)
            clientesDisponibles.remove(cliente)
            cliente.elegirPaquete(listaPaquetes.paquetesDisponibles().anyOne())
            listaPaquetes.crearPaquete(cliente.paqueteElegido())
            game.addVisual(cliente)
            game.addVisual(burbujasDisponibles.find({b=>b.cliente() == cliente}))
        }
    }

    method sacarCliente(cliente) {
        clientesActuales.remove(cliente)
        clientesDisponibles.add(cliente)
        game.removeVisual(cliente)
        game.removeVisual(burbujasDisponibles.find({b=>b.cliente() == cliente}))
        randomizadorClientesPos.liberarPosicion(cliente.position())
        cliente.actualizarPosicion()
        burbujasDisponibles.find({b=>b.cliente() == cliente}).actualizarPosicion()
    }

    method vaciarClientes() {
        clientesActuales.forEach({c=>self.sacarCliente(c)})
    }
}