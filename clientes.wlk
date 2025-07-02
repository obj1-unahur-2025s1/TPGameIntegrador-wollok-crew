import wollok.game.*
import paquetes.*

class Cliente inherits EntidadVisual{
    var paqueteElegido = null
    var imagen = ["Cliente0150.png", "Cliente0250.png", "Cliente0350.png", "Cliente0450.png"].anyOne()
    var burbuja = new BurbujaCliente(cliente = self)
   
    override method image() = imagen
    method imagenBurbujaDeCliente() = paqueteElegido.burbuja()
    
    method paqueteElegido() = paqueteElegido

    method elegirPaquete(paquete) {
        if (paquete != null) {
            paqueteElegido = paquete
        }
    }

    method actualizarPosicion() {
        position = randomizadorClientesPos.posicionAleatoriaCliente()
        imagen = ["Cliente0150.png", "Cliente0250.png", "Cliente0350.png", "Cliente0450.png"].anyOne()
        self.elegirPaquete(listaPaquetes.paquetesDisponibles().anyOne())
    }

    method burbuja() = burbuja

    method puedeRecibirElPaquete(paquete) = paqueteElegido.burbuja() == paquete.burbuja()

    method recibirPaquete(unPaquete) {
        listaClientes.sacarCliente(self)
        game.sound("drop3.mp3").play()
    }
}

class BurbujaCliente {
    const cliente
    method cliente() = cliente

    method image() = cliente.imagenBurbujaDeCliente()
    method position() = cliente.position().up(1)

    method clientepedido() = cliente.paqueteElegido() 
}

object randomizadorClientesPos {
    const todasLasPosiciones = [
        game.at(4, 4), game.at(4, 2), game.at(4, 7), game.at(9, 7), game.at(9, 3)
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
        const posLista = pos
        if (!posicionesDisponibles.contains(posLista)) {
            posicionesDisponibles.add(posLista)
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

    const clientesDisponibles = [cli1, cli2, cli3, cli4]
    const clientesActuales = []

    const burbujasDisponibles = [bur1, bur2, bur3, bur4]

    method clientesActuales() = clientesActuales

    method posiciones() = clientesActuales.map({o=>o.position()})

    method crearCliente() {
        if (clientesActuales.size() < 4) {
            const cliente = clientesDisponibles.anyOne()
            const paquete = listaPaquetes.paquetesDisponibles().anyOne()
            if (paquete != null) {
                cliente.elegirPaquete(paquete)
                listaPaquetes.crearPaquete(paquete)
                clientesActuales.add(cliente)
                clientesDisponibles.remove(cliente)
                game.addVisual(cliente)
                game.addVisual(cliente.burbuja())
            }
        }
    }

    method sacarCliente(cliente) {
        clientesActuales.remove(cliente)
        clientesDisponibles.add(cliente)
        game.removeVisual(cliente)
        game.removeVisual(cliente.burbuja())
        randomizadorClientesPos.liberarPosicion(cliente.position())
        cliente.actualizarPosicion()
    }

    method vaciarClientes() {
        clientesActuales.forEach({c=>self.sacarCliente(c)})
    }

    method reiniciar() {
        self.vaciarClientes()
        burbujasDisponibles.clear()
    }
}